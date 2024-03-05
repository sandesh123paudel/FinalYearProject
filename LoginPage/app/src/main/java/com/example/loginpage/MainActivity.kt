package com.example.loginpage

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Checkbox
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.loginpage.ui.theme.LoginPageTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            LoginPageTheme {
                LoginScreen()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen() {

    var email: String by remember {
        mutableStateOf("")
    }
    var password: String by remember {
        mutableStateOf("")
    }
    var rememberMe: Boolean by remember{
        mutableStateOf(true)
    }
    var isPasswordVisible: Boolean by remember{
        mutableStateOf(true)
    }
    val onEmailChanged:(String)->Unit={
        email=it
    }
    val onPasswordChanged: (String) -> Unit = {
        password = it
    }
    val rememberMeToggled: (Boolean) -> Unit = {
        rememberMe = it
    }
    val onPasswordToggled: () -> Unit = {
        isPasswordVisible = !isPasswordVisible
    }


    Scaffold(topBar = {
        TopAppBar(
            title = {
                Text(
                    text = "Login",
                    color = MaterialTheme.colorScheme.onPrimary,
                    style = MaterialTheme.typography.headlineSmall
                )
            }, colors = TopAppBarDefaults.topAppBarColors(
                containerColor = MaterialTheme.colorScheme.primary
            )
        )
    }) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState())
        ) {
            Text(text = "Welcome", style = MaterialTheme.typography.headlineMedium)
            Text(
                text = "Please provide your valid credentials",
                style = MaterialTheme.typography.titleLarge
            )
            TextField(modifier = Modifier
                .fillMaxWidth()
                .padding(top = 32.dp),
                value = email,
                onValueChange = onEmailChanged,

            TextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
                value = password,
                onValueChange = onPasswordChanged,
                trailingIcon = {

                    if(isPasswordVisible)
                    {

                        Icon(
                            modifier = Modifier.clickable { isPasswordVisible=!isPasswordVisible },
                            painter = painterResource(id = R.drawable.eye_off),
                            contentDescription = "Password View Icon"
                        )
                    }
                    else{
                        Icon(
                            modifier = Modifier.clickable { isPasswordVisible=!isPasswordVisible },
                            painter = painterResource(id = R.drawable.eye),
                            contentDescription = "Password View Icon"
                        )
                    }
                },
            ),


            Button(modifier = Modifier
                .padding(top = 16.dp)
                .fillMaxWidth()

                .heightIn(min = 52.dp),
                onClick = { /*TODO*/ }) {
                Text(text = "Login")
            },


            Row(
                modifier = Modifier.padding(top = 10.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {

                Checkbox(checked =rememberMe , onCheckedChange ={rememberMe=true} )
                Text(text = "Remember me.")
            },

            Text(
                modifier = Modifier.align(Alignment.End),
                text = buildAnnotatedString {

                    append("If new user")

                    withStyle(style = SpanStyle(color = MaterialTheme.colorScheme.primary
                        , textDecoration = TextDecoration.None)
                    ) {
                        append(" register ")
                    }
                    append(" here.")
                }))
        }

    }
}




@Preview
@Composable
fun PreviewLoginScreen() {
    LoginPageTheme {
        LoginScreen()
    }
}