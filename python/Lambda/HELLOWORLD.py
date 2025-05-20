import json

print("Loading function for CI CD deployment")


def lambda_handler(event, context):
    # print("Received event: " + json.dumps(event, indent=2))
    print("value1 = " + event["key1"])
    print("value2 = " + event["key2"])
    print("value3 = " + event["key3"])
    print("edit_Ram")
    print("Nice, the code is deployed")
    return event["key1"]  # Echo back the first key value
    # raise Exception('Something went wrong')
