Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C91DED4A
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729178860; cv=none; b=I1w53Acurtx0ss/8V3E/nT9l420tcpSM8HbDekeIT+RtPoROFs1imnVfFXg0Urr1qTP83APIQH0FlP+Wb2i+2feT44t0ML3kjN4PKz5ritUqJ3CR1mA2bI49ViX+WE0x5rrKVROKZumfb6GT30QqdBJvIQbdcvF5g77g7UWbNZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729178860; c=relaxed/simple;
	bh=pUsx2DUxPukBbruGfk/uIk0S4QPDzpHWo4Ll8PofPkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pKjDBjRs0/f4dscUW8kXpvjWv5wSt2f9JotuMRxpHxyqnEOflDsVIN+vDLiy5jbZ7ZwOe+GWX9WMwCG6xfJY4UPFUv9mWqOwKpbBtER69QzGcYcBNBXkaeWc8aT2TuifGFzeaNm7Yk8inEhnhMpuF3dXf/183YRFVuUCeIWP4sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W1tK5G2a; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W1tK5G2a"
Message-ID: <908e7b5f-5f9e-4ece-b000-cf88bfc0d0c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729178853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXfuEwctmIVWuoej3csv6RiD9SJ/5P0m3Jg6O4XHfYM=;
	b=W1tK5G2aOlvT4FTfGZw9LtP/KhEZFF9LcAM482AhfOfJkRozBfTq03A0YQlrUF8nLCNdUw
	GJX1C2kGSp5DYveokrRtoIXNhFhy28EFCPKZHZByfHc+EKi8cbn8nplkeBQsNBqAVfgtW1
	WzoYmEVm990GhGLCHbSs/SoeG31kQrE=
Date: Thu, 17 Oct 2024 11:27:27 -0400
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] libtraceevent: Have sizeof() parsing handle u8/s8 through
 u64/s64
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20241011154801.6e237662@gandalf.local.home>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Sean Anderson <sean.anderson@linux.dev>
In-Reply-To: <20241011154801.6e237662@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 10/11/24 15:48, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The sizeof() may be used for common types like:
> 
>  __u8, __s8, u8, s8,
>  __u16, __s16, u16, s16,
>  __u32, __s32, u32, s32,
>  __u64, __s64, u64, s64
> 
> Handle them.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/event-parse.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index ddeb3b9909c0..73563c8e9dea 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -3571,6 +3571,23 @@ process_sizeof(struct tep_event *event, struct tep_print_arg *arg, char **tok)
>  			/* The token is the next token */
>  			token_has_paren = true;
>  		}
> +
> +	} else if (strcmp(token, "__u64") == 0 || strcmp(token, "u64") == 0 ||
> +		   strcmp(token, "__s64") == 0 || strcmp(token, "s64") == 0) {
> +		arg->atom.atom = strdup("8");
> +
> +	} else if (strcmp(token, "__u32") == 0 || strcmp(token, "u32") == 0 ||
> +		   strcmp(token, "__s32") == 0 || strcmp(token, "s32") == 0) {
> +		arg->atom.atom = strdup("4");
> +
> +	} else if (strcmp(token, "__u16") == 0 || strcmp(token, "u16") == 0 ||
> +		   strcmp(token, "__s16") == 0 || strcmp(token, "s16") == 0) {
> +		arg->atom.atom = strdup("2");
> +
> +	} else if (strcmp(token, "__u8") == 0 || strcmp(token, "u8") == 0 ||
> +		   strcmp(token, "__8") == 0 || strcmp(token, "s8") == 0) {
> +		arg->atom.atom = strdup("1");
> +
>  	} else if (strcmp(token, "REC") == 0) {
>  
>  		free_token(token);

Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Tested-by: Sean Anderson <sean.anderson@linux.dev>
