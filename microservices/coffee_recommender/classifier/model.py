from torch import nn
import torch
from hyperparameters import params_dict

class DrinkClassifier(nn.Module):
    def __init__(self, in_features : int, hid_features_hid_in : int, 
                hid_features_hid_hid : int, hid_features_hid_hid_second : int, 
                hid_features_hid_hid_third : int, hid_features_hid_hid_fourth : int,
                out_features_hid_out : int):
        super().__init__()
        self.layer_input_hidden = nn.Linear(in_features=in_features, out_features=hid_features_hid_in)
        nn.init.xavier_normal_(self.layer_input_hidden.weight)
        self.bn1 = nn.BatchNorm1d(hid_features_hid_in)
        self.dropout1 = nn.Dropout(params_dict["DROPOUT_PROBABILITY_LAYER1"])
        
        self.layer_hidden_hidden = nn.Linear(in_features=hid_features_hid_in, out_features=hid_features_hid_hid)
        nn.init.xavier_normal_(self.layer_hidden_hidden.weight)
        self.bn2 = nn.BatchNorm1d(hid_features_hid_hid)
        self.dropout2 = nn.Dropout(params_dict["DROPOUT_PROBABILITY_LAYER2"])
        
        self.layer_hidden_hidden_second = nn.Linear(in_features=hid_features_hid_hid, out_features=hid_features_hid_hid_second)
        nn.init.xavier_normal_(self.layer_hidden_hidden_second.weight)
        self.bn3 = nn.BatchNorm1d(hid_features_hid_hid_second)
        self.dropout3 = nn.Dropout(params_dict["DROPOUT_PROBABILITY_LAYER3"])

        self.layer_hidden_hidden_third = nn.Linear(in_features=hid_features_hid_hid_second, out_features=hid_features_hid_hid_third)
        nn.init.xavier_normal_(self.layer_hidden_hidden_third.weight)
        self.bn4 = nn.BatchNorm1d(hid_features_hid_hid_third)
        self.dropout4 = nn.Dropout(params_dict["DROPOUT_PROBABILITY_LAYER4"])

        self.layer_hidden_hidden_fourth = nn.Linear(in_features=hid_features_hid_hid_third, out_features=hid_features_hid_hid_fourth)
        nn.init.xavier_normal_(self.layer_hidden_hidden_fourth.weight)
        self.bn5 = nn.BatchNorm1d(hid_features_hid_hid_fourth)
        self.dropout5 = nn.Dropout(params_dict["DROPOUT_PROBABILITY_LAYER5"])

        self.layer_hidden_output = nn.Linear(in_features=hid_features_hid_hid_fourth, out_features=out_features_hid_out)
        nn.init.xavier_normal_(self.layer_hidden_output.weight)
        self.relu = nn.ReLU()
    
    def forward(self, X : torch.float32) -> torch.Tensor:
        z1 = self.layer_input_hidden(X)
        z1 = self.bn1(z1)
        a1 = self.relu(z1)
        a1 = self.dropout1(a1)

        z2 = self.layer_hidden_hidden(a1)
        z2 = self.bn2(z2)
        a2 = self.relu(z2)
        a2 = self.dropout2(a2)

        z3 = self.layer_hidden_hidden_second(a2)
        z3 = self.bn3(z3)
        a3 = self.relu(z3)
        a3 = self.dropout3(a3)

        z4 = self.layer_hidden_hidden_third(a3)
        z4 = self.bn4(z4)
        a4 = self.relu(z4)
        a4 = self.dropout4(a4)

        z5 = self.layer_hidden_hidden_fourth(a4)
        z5 = self.bn5(z5)
        a5 = self.relu(z5)
        a5 = self.dropout5(a5)

        z6 = self.layer_hidden_output(a5)
        a6 = self.relu(z6)
        return a6