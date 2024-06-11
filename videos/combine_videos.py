from typing import Union
import os 
from moviepy.editor import VideoFileClip, ColorClip, concatenate_videoclips, clips_array, VideoClip, CompositeVideoClip

def extend_video(video : VideoFileClip, max_duration) -> Union[VideoFileClip, Union[VideoClip, CompositeVideoClip]]:
    if video.duration < max_duration:
        black_clip : ColorClip = ColorClip(size=video.size, color=(0, 0, 0), duration=(max_duration - video.duration))
        extended_video : Union[VideoClip, CompositeVideoClip] = concatenate_videoclips([video, black_clip])
        return extended_video
    else:
        return video

def create_video(output_video_name : str = "combined_video.mp4") -> None:
    current_directory : str = os.getcwd()
    video_mobile_application_path : str = os.path.join(current_directory, "dissertation_video_mobile_application.mp4")
    video_pc_path : str = os.path.join(current_directory, "dissertation_video_pc.mp4")
    video_coffee_machine_path : str = os.path.join(current_directory, "dissertation_coffee_machine.mp4")

    video_mobile_application : VideoFileClip = VideoFileClip(filename=video_mobile_application_path)
    video_pc : VideoFileClip = VideoFileClip(filename=video_pc_path)
    video_coffee_machine : VideoFileClip = VideoFileClip(filename=video_coffee_machine_path)

    max_duration : float = max(video_mobile_application.duration, video_pc.duration, video_coffee_machine.duration)
    height : float = min(video_mobile_application.h, video_pc.h, video_coffee_machine.h)

    video_mobile_application : Union[VideoFileClip, Union[VideoClip, CompositeVideoClip]] = extend_video(video=video_mobile_application, max_duration=max_duration)
    video_pc : Union[VideoFileClip, Union[VideoClip, CompositeVideoClip]] = extend_video(video=video_pc, max_duration=max_duration)
    video_coffee_machine : Union[VideoFileClip, Union[VideoClip, CompositeVideoClip]] = extend_video(video=video_coffee_machine, max_duration=max_duration)

    video_mobile_application : VideoFileClip = video_mobile_application.resize(height=height)
    video_pc : VideoFileClip = video_pc.resize(height=height)
    video_coffee_machine : VideoFileClip = video_coffee_machine.resize(height=height)

    final_video : CompositeVideoClip = clips_array([[video_mobile_application, video_pc, video_coffee_machine]])

    final_video.write_videofile(output_video_name)

if __name__ == "__main__":
    output_video_name : str = "dissertation_project_video.mp4"
    create_video(output_video_name=output_video_name)
