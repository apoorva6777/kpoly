package backend;
import org.junit.Before;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.*;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@SpringBootTest(webEnvironment=WebEnvironment.MOCK, classes={ Ping.class })
@AutoConfigureMockMvc 
public class PingTest {

	@Value("${server.port}")
	private int port;
	
	 @Autowired
	 private MockMvc mockMvc;

	@Mock
	@Autowired
	private Ping ping;
	
	@Test
	public void contextLoads() throws Exception {
		this.mockMvc.perform(get("/api/status"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.message").value("Status check successful!!"));
	}
	
}


