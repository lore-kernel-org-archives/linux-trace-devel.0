Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A26135948
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Dec 2024 22:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734561413; cv=none; b=utKY9ROb/ZvYfc8GuLJdpIYg7RJBWHgOdi0l8W1y00yH+FSPq56SppXvjGTftN08Oz7yQqtCUfhHeilH7eq6jaMWPleT98x9E2Tgsb16PhzSi2n0601hAHJXCML6AqkjV5q2TMVsgReJ8p/hF+vUmaMLhPT3zURhq5Akf3CilXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734561413; c=relaxed/simple;
	bh=8Myyz3XcCLS2VgXB8J+i/+Pna0bCwFQkV8Q/BaCHs/U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uDBAIzaPmo8+YW4gQcL/X4KQg7tw+SEIMGg+Pmq+/2+bvXTxTFfC4lmVJgkeucL8Nk3qWiu594Wmmq3oA1O198179b/wQojqUTTJMKjcdRaPTwZx4LgNFd7+qbVMPdJExDbFJvybUk3KzhtJVLvN0JsUArE08GFMVdD6F5seLCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632DEC4CECD;
	Wed, 18 Dec 2024 22:36:52 +0000 (UTC)
Date: Wed, 18 Dec 2024 17:37:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/7] trace-cmd lib: Close FDs in
 create_buffer_recorder_fd2 it allocation fails
Message-ID: <20241218173731.67e8e865@gandalf.local.home>
In-Reply-To: <20241205144439.127564-2-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
	<20241205144439.127564-2-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Dec 2024 15:44:33 +0100
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> The behavior of create_buffer_recorder_fd2() wrt closing the file
> descriptors is inconsistent. They aren't close if the function fails
> early when allocating recorder, but they are closed in
> tracecmd_free_recorder() if it fails later.
> 
> This cause use-after-free access when the caller tries to close the
> FDs afterwards.
> 
> Always close the FDs in create_buffer_recorder_fd2() when it fails and
> stop the caller to close them themselves.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  lib/trace-cmd/trace-recorder.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
> index 44f245d5..0413e529 100644
> --- a/lib/trace-cmd/trace-recorder.c
> +++ b/lib/trace-cmd/trace-recorder.c
> @@ -114,8 +114,12 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
>  	bool nonblock = false;
>  
>  	recorder = malloc(sizeof(*recorder));
> -	if (!recorder)
> +	if (!recorder) {
> +		close(fd);
> +		if (fd2 != -1)
> +			close(fd2);
>  		return NULL;
> +	}

No. If a function does not open a file descriptor, it should not close it.
It's bad programming style if a called function closes a file descriptor on
error that was passed to it. That can easily introduce new bugs.

The fix is to not have it close a file descriptor at all!

-- Steve

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0413e5293766..df971e4adf97 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -69,7 +69,7 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	if (!recorder)
 		return;
 
-	if (recorder->max) {
+	if (recorder->max && recorder->fd >= 0) {
 		/* Need to put everything into fd1 */
 		if (recorder->fd == recorder->fd1) {
 			int ret;
@@ -140,14 +140,12 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	recorder->count = 0;
 	recorder->pages = 0;
 
-	/* fd always points to what to write to */
-	recorder->fd = fd;
-	recorder->fd1 = fd;
-	recorder->fd2 = fd2;
-
 	if (recorder->flags & TRACECMD_RECORD_POLL)
 		nonblock = true;
 
+	/* In case of error */
+	recorder->fd = -1;
+
 	if (tfd >= 0)
 		recorder->tcpu = tracefs_cpu_alloc_fd(tfd, recorder->page_size, nonblock);
 	else
@@ -156,6 +154,11 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	if (!recorder->tcpu)
 		goto out_free;
 
+	/* fd always points to what to write to */
+	recorder->fd = fd;
+	recorder->fd1 = fd;
+	recorder->fd2 = fd2;
+
 	recorder->subbuf_size = tracefs_cpu_read_size(recorder->tcpu);
 	return recorder;
 
