import { Injectable, Response} from '@nestjs/common';
import { Response as Res } from 'express';
@Injectable()
export class PingService {
  getPing(@Response() res: Res) : Res {
    const response ={
      status: 200,
      message: "Ping Successful!!",
    };
    res.header('Access-Control-Allow-Methods', 'GET, POST');
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers' , '*');
    return res.status(200).send(JSON.stringify(response));
  }
}
// out