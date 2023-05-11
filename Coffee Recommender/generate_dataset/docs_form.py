from __future__ import print_function
import os, re
from apiclient import discovery
from httplib2 import Http
from oauth2client import client, file, tools
from typing import List, Dict, Tuple
import boto3

SCOPES               = ["https://www.googleapis.com/auth/forms.body.readonly", "https://www.googleapis.com/auth/forms.responses.readonly"]
DISCOVERY_DOC        = "https://forms.googleapis.com/$discovery/rest?version=v1"
SERVICE_ACCOUNT_FILE = "service_account.json"
CREDENTIALS          = "credentials.json"
DIRNAME              = os.path.dirname(__file__)

def work_json(questions : dict, answers : dict) -> str|None:
    answers_questions = []
    answers_ids = [] 
    for i in range(len(answers["responses"])):
        body = answers["responses"][i]
        answers_question = []
        answer_ids = []
        for values in body["answers"].values():
            answer_ids.append(values["questionId"])
            text_answers = values["textAnswers"]
            for t_answers in text_answers.values():
                answer = t_answers[0]["value"]
                answers_question.append(answer)
        answers_ids.append(answer_ids)
        answers_questions.append(answers_question)
    expected_ids = ["15d5e85a", "06fd1b21", "0a5e4d3e", "11714448", "1c9bc60a", "350d1398", "3cb5a401", "11ecf803"]
    answers_questions = sort_question_by_expected_ids(expected_ids, answers_questions, answers_ids)
    answers_questions = swap_columns(answers_questions)
    options_questions = [] 
    item_list = questions["items"]
    for i in range(len(item_list)):
        options_question = []
        question = item_list[i]["title"].strip()
        question = re.sub(pattern=r'^[\W\n]+|[\W\n]+$', repl='', string=question)
        options = item_list[i]["questionItem"]["question"]["choiceQuestion"]["options"]
        options_question.append(question)
        for option in options:
            options_question.append(option["value"])
        options_questions.append(options_question)
    response : str|None = save_the_questions_in_dynamoDB(options_questions)
    if response is not None:
        return response
    debug_file(os.path.join(DIRNAME, "debug_log.txt"), answers_questions, options_questions)
    merge_samples_from_real_people_with_the_ones_generated_by_gpt4(os.path.join(DIRNAME, "drinks_dataset.txt"), \
                                                                   options_questions, answers_questions)

def format_json_request(options_questions: List[List[str]]) -> Dict[str, Dict[str, Dict[str, List[Dict[str, Dict[str, str]]]]]]:
    out_options_questions: Dict[str, Dict[str, List[Dict[str, Dict[str, str]]]]] = \
        {"questionId": {"S": "09423213"}, "questions": {"L": []}}
    for o_q in options_questions:
        question : Dict[str, Dict[str, Dict[str, str]]] = {"M": {"question": {"S": o_q[0]}}}
        options : Dict[str, Dict[str, Dict[str, List[str]]]]= {"M": {"options": {"L": []}}}
        for j in range(1, len(o_q)):
            options["M"]["options"]["L"].append({"S": o_q[j]})
        out_options_questions["questions"]["L"].append(question)
        out_options_questions["questions"]["L"].append(options)
    return out_options_questions

def save_the_questions_in_dynamoDB(options_questions : List[List[str]]) -> str|None:   
    error_msg : str|None = None
    data : List[Dict[Dict[str, str], Dict[str,List[str]]]] = format_json_request(options_questions)
    dynamodb = boto3.client("dynamodb", region_name="us-east-1")
    try:
        response = dynamodb.put_item(
            TableName = "drinkQuestionnaire",
            Item = data
        )
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print("Data added successfully")
        else:
            print("Error adding data")
    except Exception as e:
        error_msg = f"Error: {e}, when adding the data"
    return error_msg

def debug_file(path : str, answers : List[List[str]], questions : List[List[str]]) -> None:
    with open(path, 'w') as file:
        for i, _answers in enumerate(answers): file.write(str(i)+") "+str(_answers)+"\n")
        file.write("\n")
        for i, _questions in enumerate(questions): file.write(str(i)+") "+str(_questions)+"\n")

def swap_columns(questions : List[List[str]]) -> List[List[str]]:
    for _questions in questions:
        if _questions[6] != "Yes" or _questions[6] != "No":
            _questions[6], _questions[5] = _questions[5], _questions[6]
    return questions

def sort_question_by_expected_ids(expected_ids : List[str], questions : List[List[str]], ids : List[List[str]]) -> List[List[str]]:
    for _questions, _ids in zip(questions, ids):
        number_ids = len(_questions)
        for i in range(number_ids):
            id = expected_ids[i]
            for j in range(i, number_ids):
                if id == _ids[j]:
                    _questions[i], _questions[j] = _questions[j], _questions[i]
                    break
    return questions
    
def read_and_trim_samples_generated_by_gpt4(path : str) -> str:
    with open(path, "r") as file:
        content = "\n".join([re.sub(pattern=r'\s*,\s*', repl=',', string=line[:-2].lower()) if line.endswith('.\n') \
                             else re.sub(r'\s*,\s*', ',', line[:-1].lower()) for line in file.readlines()])
    return content

def format_samples_and_features(questions : List[List[str]], answers_samples : List[List[str]]) -> Tuple[str, str]:
    columns, rows = "", ""  

    for (i, q_and_o) in enumerate(questions):
        for (j, q) in enumerate(q_and_o): 
            q = re.match(pattern=r"^.*?(?=\?|:)|^[^:]+$", string=q).group(0).strip() # get only useful data for questions
            if i == (len(questions) - 1): columns += f"{q[3:].lower()}" 
            else: columns += f"{q[3:].lower()},"
            break   

    for answs in answers_samples:
        for (j, answ) in enumerate(answs):
            if j == len(answs) - 1: rows += f"{answ.lower()}"
            else: rows += f"{answ.lower()},"
        rows += f"\n"

    return (columns, rows)

def merge_samples_from_real_people_with_the_ones_generated_by_gpt4(path : str, features_people : str, samples_people : str) -> None:
    samples_gpt4 = read_and_trim_samples_generated_by_gpt4(os.path.join(DIRNAME, "samples_generated_with_gpt4.txt"))
    features_people, samples_people = format_samples_and_features(features_people, samples_people)
    create_dataset(os.path.join(DIRNAME, "coffee_dataset.txt"), features_people, samples_gpt4, samples_people)

def create_dataset(path : str, features_people : str, samples_gpt4 : str, samples_people : str) -> None:
    with open(path, "w") as file:
        file.write(f"{features_people}\n{samples_gpt4}\n{samples_people}")
        
if __name__ == "__main__":
    store = file.Storage('token.json')
    creds = None
    if not creds or creds.invalid:
        flow : client.OAuth2WebServerFlow = client.flow_from_clientsecrets(CREDENTIALS, SCOPES)
        creds = tools.run_flow(flow, store)
        service = discovery.build('forms', 'v1', http=creds.authorize(
        Http()), discoveryServiceUrl=DISCOVERY_DOC, static_discovery=False)
    form_id : str = "1tEauj7n4n86CiCB-49YOfKbe1I62QWOlluDzcjytxng" # url where the form with the questions is located
    questions = service.forms().get(formId=form_id).execute()
    answers = service.forms().responses().list(formId=form_id).execute()
    work_json(questions, answers)