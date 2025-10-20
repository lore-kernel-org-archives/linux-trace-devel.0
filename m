Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0324E1F875A
	for <linux-trace-devel@vger.kernel.org>; Mon, 20 Oct 2025 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760977032; cv=none; b=koAqKmA0fTPSi0D6M8FMZLHMeZz0UjOjpTuZw0KlgX0U5J/mkPvR1ohmYhcaZrlx0f3MpPGyYpmt+iOqL4aE1MDw7X/m+WK515JdkOnsynn3iqKveJ4VqN9TkXI27KJ/WkdBGoWK1EVH4QXrgWfT6YYckhv8RyZznAAih6Uvjuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760977032; c=relaxed/simple;
	bh=H9VkACThFPLAi2hCvxuatat46txfURWCWqXJWAFK99Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WmlF5L8vh0+X7iGEXL3cU21NL0t7ATHanCftbixM1FYjNy16O4BfYbnIOhq04eoD9QB9+0g4nfiFOeptjoc1clk2649mGVbo2ZviXBAUil1Mu6vJyba2bjwzHmiekmif5h/7vHYnTNCQtJE4RCMrvE0VVHW0NokglGhsDkI8qTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tvi3PNGj; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tvi3PNGj"
Message-ID: <b2c14f3a-b023-4688-9198-1f9b3e71320f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760977028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y31gx+JgOGOkWUUMEOiEbmUvVKPpSmT/TRlWYtXvi2k=;
	b=Tvi3PNGjxcyiFuM4OktAsl5vG/DlCJ6IWaCCsV81J9F4EUa+UWtz4j1CoI+QyDaqZ6fdoS
	QliRgHymhZKR0d2tp53g0L4yiD/mpXf6D9Pmq5/I6+MnLLvRJ3u8hAkToBzHPA7su6Zlg+
	YiLeIdGGFV76JXPSa3sfBKlQlj+7ySc=
Date: Mon, 20 Oct 2025 12:17:05 -0400
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] Print arrays like Linux does
To: linux-trace-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
References: <20240826210022.2251838-1-sean.anderson@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Sean Anderson <sean.anderson@linux.dev>
In-Reply-To: <20240826210022.2251838-1-sean.anderson@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 8/26/24 17:00, Sean Anderson wrote:
> In Linux, trace_print_array_seq prints array elements as hexadecimal
> numbers, separates them with commas, and surrounds the whole thing with
> curly braces. Modify print_str_arg to use the same formatting.
> 
> Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
> ---
> 
>  src/event-parse.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index ba4a153..3c6f6f2 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -4938,18 +4938,19 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  		len = eval_num_arg(data, size, event, arg->int_array.count);
>  		el_size = eval_num_arg(data, size, event,
>  				       arg->int_array.el_size);
> +		trace_seq_putc(s, '{');
>  		for (i = 0; i < len; i++) {
>  			if (i)
> -				trace_seq_putc(s, ' ');
> +				trace_seq_putc(s, ',');
>  
>  			if (el_size == 1) {
> -				trace_seq_printf(s, "%u", *(uint8_t *)num);
> +				trace_seq_printf(s, "0x%x", *(uint8_t *)num);
>  			} else if (el_size == 2) {
> -				trace_seq_printf(s, "%u", *(uint16_t *)num);
> +				trace_seq_printf(s, "0x%x", *(uint16_t *)num);
>  			} else if (el_size == 4) {
> -				trace_seq_printf(s, "%u", *(uint32_t *)num);
> +				trace_seq_printf(s, "0x%x", *(uint32_t *)num);
>  			} else if (el_size == 8) {
> -				trace_seq_printf(s, "%"PRIu64, *(uint64_t *)num);
> +				trace_seq_printf(s, "0x%"PRIx64, *(uint64_t *)num);
>  			} else {
>  				trace_seq_printf(s, "BAD SIZE:%d 0x%x",
>  						 el_size, *(uint8_t *)num);
> @@ -4958,6 +4959,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  
>  			num += el_size;
>  		}
> +		trace_seq_putc(s, '}');
>  		break;
>  	}
>  	case TEP_PRINT_TYPE:

ping
