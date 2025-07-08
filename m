Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D9E1CD1E4
	for <linux-trace-devel@vger.kernel.org>; Tue,  8 Jul 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751999072; cv=none; b=rInlSBIk1O1ZJead8a00kslLCyLsvjvE6PXXz8gDJibysKwAPGooiKmc/PEyOIxvwkHBzz/iWkODIHpDAZqmIiMuyTxv6yPyFp5bkceRm8h5EpOm0dYVHjM2Af47ayJaPpgTT+p/+dFnrb6Cy20GovVzEMx/UwgPPKTcTXxVWXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751999072; c=relaxed/simple;
	bh=0hkdCyhXTE5mMvoVJTc4YFLRkz7+6lltU218Io+azpM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BpdDA/bBt7aB4bw37LaumByD7oTLJ38+Weph7inspksQ9iTlDd6e1yjJcGay98Mi/C1eo7I6fRYM44Daq057/a0f8KQnwq+vxi1neZZWZNS0mafYuvJQYeNID1CzsuozsEIcs/v8X15dFD3rBhIopGO/FeDQUpNNDKyPmFg1ipM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A313127D00;
	Tue,  8 Jul 2025 18:24:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 5D5A42000D;
	Tue,  8 Jul 2025 18:24:26 +0000 (UTC)
Date: Tue, 8 Jul 2025 14:24:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] libtracecmd: Support changing /proc/kallsyms
Message-ID: <20250708142427.7ace6eac@gandalf.local.home>
In-Reply-To: <20250602214154.446881-3-iii@linux.ibm.com>
References: <20250602214154.446881-1-iii@linux.ibm.com>
	<20250602214154.446881-3-iii@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5D5A42000D
X-Rspamd-Server: rspamout02
X-Stat-Signature: yztfozxyuehxifro9pctb5jwn5hnxgur
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18qy6nF3TZd3xho0lhwIw+I7z9cx7a4i6I=
X-HE-Tag: 1751999066-92867
X-HE-Meta: U2FsdGVkX183bOd0THSKhbCZVE0hVjUT78NzIbbTmz+8lzqzrEbY/o6tBV46vI2wVUuYhtBvHRcHRxN8URN0JbFN5Fql4QTltQBNiw2YPxeyy/aHkV2pb4B0X1CjPMO34tWw0RXrDqSF3ZLgB1Di6GLWQQkrBYxTDM4HClF9vmHpbrLx04ANEhbvfA5jjFNsOQr4r5ZxPBe1ul4fjnGiDaAGoPAsmDGuNh+BIWxQLPhJxbadEf6V1tUA7/IXskLcqaAu33vIj0NSnEwg8c5/i5+567+tGiUQ72UsSqf0LY2I3TXE+clHIlTDVuUIViLdlhY5A1b4D4DO2fm360nEv12SWWQ4SYE7


Sorry for the late reply, been way too busy on the kernel side.

On Mon,  2 Jun 2025 22:38:33 +0100
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

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
> Fix by updating the size. This will work even for sending trace data
> over the network thanks to trace_msg_cache.

I'm perfectly fine with the logic, just some nits about the patch.
Could you send a v3? Comments below.

> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  lib/trace-cmd/trace-output.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 00b87a19..e9ec8f51 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -577,6 +577,27 @@ __hidden int tcmd_out_update_section_header(struct tracecmd_output *handle, tsiz
>  	return 0;
>  }
>  

Needs a comment here:

/*
 * For files that can change while reading it (like /proc/kallsyms) the
 * normal "size != check_size" can fail. That's because from the time
 * the file size is read to write in the size to the time it is read to copy
 * it into the file, it can change. In this case, the size that was stored
 * in the file needs to be updated.
 */
> +static int tcmd_out_update_endian_4(struct tracecmd_output *handle,
> +				    off_t offset, int val)

This is a static function, it doesn't need the "tcmd_" prefix. That should
be reserved for global functions that are "__hidden".

> +{
> +	tsize_t current;
> +	int endian4;
> +
> +	if (offset == (off_t)-1)
> +		return -1;

Add newline here.

> +	current = do_lseek(handle, 0, SEEK_CUR);
> +	if (current == (off_t)-1)
> +		return -1;

And here.

> +	if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
> +		return -1;

And here.

> +	endian4 = convert_endian_4(handle, val);
> +	if (tcmd_do_write_check(handle, &endian4, 4))
> +		return -1;

And here.

> +	if (do_lseek(handle, current, SEEK_SET) == (off_t)-1)
> +		return -1;

And here.

Other than that, looks good.

-- Steve

> +	return 0;
> +}
> +
>  static int save_string_section(struct tracecmd_output *handle, bool compress)
>  {
>  	enum tracecmd_section_flags flags = 0;
> @@ -1134,6 +1155,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
>  	enum tracecmd_section_flags flags = 0;
>  	unsigned int size, check_size, endian4;
>  	const char *path = "/proc/kallsyms";
> +	off_t size_offset;
>  	tsize_t offset;
>  	struct stat st;
>  	int ret;
> @@ -1165,13 +1187,15 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
>  	}
>  	size = get_size(path);
>  	endian4 = convert_endian_4(handle, size);
> +	size_offset = do_lseek(handle, 0, SEEK_CUR);
>  	ret = tcmd_do_write_check(handle, &endian4, 4);
>  	if (ret)
>  		goto out;
>  
>  	set_proc_kptr_restrict(0);
>  	check_size = copy_file(handle, path);
> -	if (size != check_size) {
> +	if (size != check_size &&
> +	    tcmd_out_update_endian_4(handle, size_offset, check_size)) {
>  		errno = EINVAL;
>  		tracecmd_warning("error in size of file '%s'", path);
>  		set_proc_kptr_restrict(1);

