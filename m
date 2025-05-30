Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CD12116F2
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 20:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748637839; cv=none; b=SXv2Q8EsYbubpaqaXzPqYNd+666IxRAzUsbtErwaoTCx42vzoudkCC3PNvdm2tOapDbEc9AvBu8nXTuXY9T2vf5cN3yPvbYAFsFl1wx/AJi3IHVnQtKlBFk1Y4D0ON62wBFNcynoZQgt+KyaEWrdM4pe3nMc7kLc7bOBDHQ17q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748637839; c=relaxed/simple;
	bh=d7oMJn8ueiPih02A40p5P79f3AvDCo7q6m5/eKbxMHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NaSf+1n1LZh14gNmB+QfNPu8N3qXTMP5p53jrzhO3WOgl0OEGjxnpIHIrFuuzV9+B2zx5X5yYf42xluRyZrnpr9pqrKj1Ik+iIL4OORBV2JK9gPcVDpxGpRJy9APGVNM1HJ/NkSr25TiqviTd0XA2Gh3GMleSQZ+InxAV7Kt+A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C0FC4CEE9;
	Fri, 30 May 2025 20:43:58 +0000 (UTC)
Date: Fri, 30 May 2025 16:45:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>
Subject: Re: [PATCH] libtracecmd: Support changing /proc/kallsyms
Message-ID: <20250530164502.4adf0c06@gandalf.local.home>
In-Reply-To: <20250416231325.14113-1-iii@linux.ibm.com>
References: <20250416231325.14113-1-iii@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Apr 2025 01:13:00 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

I finally got some time to look at this. Sorry for the delay.

> Running BPF selftests under trace-cmd intermittently fails with:
> 
>     error in size of file '/proc/kallsyms'
> 
> This is because these selftests load and unload BPF programs.
> bpf_prog_put() uses workqueues and RCU, so these programs disappear
> from /proc/kallsyms after a delay.
> 
> trace-cmd reads /proc/kallsyms twice: the first time to compute its
> size, and the second time to copy it into the trace file. If the
> resulting sizes don't match, which is what happens in this case,
> recording fails.
> 
> Fix by first copying /proc/kallsyms into a temporary file, and then
> into the trace file. An alternative would be to read it into a
> malloc()-ed buffer, but this would increase trace-cmd memory usage,
> since /proc/kallsyms can be a few dozen megabytes large. In case
> /tmp is tmpfs, both solutions are almost equivalent.

Actually, when compression is set, the file is already read into memory,
and then it is compressed. In fact, it's allocated twice!

The size is copied into this temp buffer. I wonder if we could just update
the size if it is different?

__hidden long long
tcmd_do_write_check(struct tracecmd_output *handle, const void *data, long long size)
{
	if (handle->do_compress)
		return tracecmd_compress_buffer_write(handle->compress, data, size);

	if (handle->msg_handle)
		return tracecmd_msg_data_send(handle->msg_handle, data, size);

	return __do_write_check(handle->fd, data, size);
}

Now for the "do_compress" we can just update the handle->buffer[] as the
size is the first thing written into it.

For the __do_write_check() we can save the file descriptor location and go
back and update what was written.

For the "->msg_handle", for now just error out. Unless you are running bpf
programs while using trace-cmd on guests or sending off the network?

-- Steve
