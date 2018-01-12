Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933917AbeALPN0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 10:13:26 -0500
Date: Fri, 12 Jan 2018 10:13:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180112101323.547a026e@gandalf.local.home>
In-Reply-To: <20171221152520.25867-2-vladislav.valtchev@gmail.com>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
        <20171221152520.25867-2-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 21 Dec 2017 17:25:18 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

> -static char read_proc(void)
> +/*
> + * Returns:
> + *   -1 - Something went wrong
> + *    0 - File does not exist (stack tracer not enabled)
> + *    1 - Success
> + */
> +static int read_proc(int *status)
>  {
> -	char buf[1];
> +	struct stat stat_buf;
> +	char buf[64];
> +	long num;
>  	int fd;
>  	int n;
>  
> +	if (stat(PROC_FILE, &stat_buf) < 0) {
> +		/* stack tracer not configured on running kernel */
> +		*status = 0; /* not configured means disabled */
> +		return 0;
> +	}
> +
>  	fd = open(PROC_FILE, O_RDONLY);
> -	if (fd < 0)
> -		die("reading %s", PROC_FILE);
> -	n = read(fd, buf, 1);
> -	close(fd);
> -	if (n != 1)
> +
> +	if (fd < 0) {
> +		/* we cannot open the file: likely a permission problem. */
> +		return -1;
> +	}
> +
> +	n = read(fd, buf, sizeof(buf));
> +
> +	/* We assume that the file is never empty we got no errors. */

The above comment does not parse.

> +	if (n <= 0)
>  		die("error reading %s", PROC_FILE);
>  
> -	return buf[0];
> +	/* Does this file have more than 63 characters?? */
> +	if (n >= sizeof(buf))
> +		return -1;

We need to close fd before returning, otherwise we leak a file
descriptor.

We can move the close right after the read up above.

> +
> +	/* n is guaranteed to be in the range [1, sizeof(buf)-1]. */
> +	buf[n] = 0;
> +	close(fd);
> +
> +	errno = 0;
> +
> +	/* Read an integer from buf ignoring any non-digit trailing characters. */

We don't really need to comment what strtol() does ;-) That's what man
pages are for.

> +	num = strtol(buf, NULL, 10);
> +
> +	/* strtol() returned 0: we have to check for errors */

Actually, a better comment is, why would strtol return zero and this
not be an error?

> +	if (!num && (errno == EINVAL || errno == ERANGE))
> +		return -1;
> +
> +	if (num > INT_MAX || num < INT_MIN)
> +		return -1; /* the number is good but does not fit in 'int' */

Don't need the comment after the above return. The INT_MAX and INT_MIN
are self describing.

> +
> +	*status = num;
> +	return 1; /* full success */
>  }
>  
> -static void start_stop_trace(char val)
> +/* NOTE: this implementation only accepts new_status in the range [0..9]. */
> +static void change_stack_tracer_status(int new_status)
>  {
>  	char buf[1];
> +	int status;
>  	int fd;
>  	int n;
>  
> -	buf[0] = read_proc();
> -	if (buf[0] == val)
> -		return;
> +	if (read_proc(&status) > 0 && status == new_status)
> +		return; /* nothing to do */
>  
>  	fd = open(PROC_FILE, O_WRONLY);
> +

Don't add a new line here. It's common to have the error check
immediately after the function.

>  	if (fd < 0)
>  		die("writing %s", PROC_FILE);

If you want a new line, you can add it here.

> -	buf[0] = val;
> +	buf[0] = new_status + '0';

If you are paranoid, we can make new_status unsigned int, or even
unsigned char, and add at the beginning of the function:

	if (new_status > 9) {
		warning("invalid status %d\n", new_status);
		return;
	}

>  	n = write(fd, buf, 1);
>  	if (n < 0)
>  		die("writing into %s", PROC_FILE);
> @@ -88,12 +131,12 @@ static void start_stop_trace(char val)
>  
>  static void start_trace(void)
>  {
> -	start_stop_trace('1');
> +	change_stack_tracer_status(1);
>  }
>  
>  static void stop_trace(void)
>  {
> -	start_stop_trace('0');
> +	change_stack_tracer_status(0);
>  }
>  
>  static void reset_trace(void)
> @@ -123,8 +166,12 @@ static void read_trace(void)
>  	char *buf = NULL;
>  	size_t n;
>  	int r;
> +	int status;

Remember, upside down x-mas trees.

	int status;
	int r;

-- Steve

>  
> -	if (read_proc() == '1')
> +	if (read_proc(&status) <= 0)
> +		die("Invalid stack tracer state");
> +
> +	if (status > 0)
>  		printf("(stack tracer running)\n");
>  	else
>  		printf("(stack tracer not running)\n");
