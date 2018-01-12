Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:58886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933994AbeALPn6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 10:43:58 -0500
Date: Fri, 12 Jan 2018 10:43:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] trace-cmd: Remove the die() call from
 read_proc()
Message-ID: <20180112104355.01ea2c86@gandalf.local.home>
In-Reply-To: <20171221152520.25867-3-vladislav.valtchev@gmail.com>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
        <20171221152520.25867-3-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 21 Dec 2017 17:25:19 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

> As trace-stack.c's read_proc() function is going to be used by trace-cmd stat,
> we don't want it to make the program die in case something went wrong.
> Therefore, this simple patch makes read_proc() to just return -1 in case the
> proc file was empty or read() failed with an error, instead of using die().
> 
> Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
> ---
>  trace-stack.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/trace-stack.c b/trace-stack.c
> index c1058ca..d55d994 100644
> --- a/trace-stack.c
> +++ b/trace-stack.c
> @@ -79,9 +79,9 @@ static int read_proc(int *status)
>  
>  	n = read(fd, buf, sizeof(buf));
>  
> -	/* We assume that the file is never empty we got no errors. */
> +	/* The file was empty or read() failed with an error. */
>  	if (n <= 0)
> -		die("error reading %s", PROC_FILE);
> +		return -1;
>  
>  	/* Does this file have more than 63 characters?? */
>  	if (n >= sizeof(buf))

But you need to handle the error cases for the users of read_proc().
>From the previous patch:

 static void change_stack_tracer_status(int new_status)
 {
	char buf[1];
	int status;
	int fd;
	int n;
 
	if (read_proc(&status) > 0 && status == new_status)
		return; /* nothing to do */

We should not continue if read_proc() fails. Should move the die here:

	ret = read_proc(&status);
	if (ret < 0)
		die("error reading %s", PROC_FILE);

	if (ret > 0 && status == new_status)
		return; /* nothing to do */

-- Steve

 
 	fd = open(PROC_FILE, O_WRONLY);
 	if (fd < 0)
 		die("writing %s", PROC_FILE);

	buf[0] = new_status + '0';
 	n = write(fd, buf, 1);
