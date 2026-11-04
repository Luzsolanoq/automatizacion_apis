package practica;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class PracticaTest {

    @Test
    void testParallel() {
        Results results = Runner.path( "classpath:practica/regresion/practica.feature",
                        "classpath:practica/regresion/administrador.feature")
                //.outputCucumberJson(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
