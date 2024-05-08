package backend;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;

import java.util.HashMap;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api")
@EnableAutoConfiguration
public class Ping {

	@GetMapping("/status")
	@ResponseBody
    public HashMap<String, String> ping() {
		HashMap<String, String> map = new HashMap<>();
	    map.put("status", "200");
	    map.put("message", "Status check successful!!");
	    return map;
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Ping.class, args);
    }		

}
