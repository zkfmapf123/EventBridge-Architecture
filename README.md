# EventBridge Architecture

![eda](./public/1.png)

## Desc

- Service
    - Blue
    - Purple
    - Green

- 내부 Internal 통신이 아닌, EventBridge 기반 통신
- EventBridge Role Based 기반으로 Service 팀내에서 관리 가능하도록 구성
- Rule 한개당 대상은 1개로 유지 (Best Practice)
- DLQ 큐는 Service Context 당 1개로 유지

## API Gateway

![2](./public/2.png)

- /blue/{proxy+}
    - http://[BLUE_ALB_DNS]/{proxy}
- /green/{proxy+}
    - http://[GREEN_ALB_DNS]/{proxy}
- /purple/{proxy+}
    - http://[PURPLE_ALB_DNS]/{proxy}