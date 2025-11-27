Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F90334387
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Nov 2025 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254668; cv=none; b=uiYk/+3/Cu4JtT8wRivdmHmGeYqlXNheLGPqxLdh3/2MYLcxtYCOE600F17a5Vv1X4GvT5RX5YYvIRgiX/2BTJFPsUaZMB0Ifhk1fQcCKVDYsZ2IwiCXHI5PlCExMkbmrRwhi80vOtvCB9ZVyM0pzm+AA7EPydePFIA4PC2IEes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254668; c=relaxed/simple;
	bh=lkeqBzOszajU4an14g4qW30cnIGcLoLkWSiHdL6OHyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Azv4JTzpCAgSaZOec80UjMbryHkJ0lKfLcywLMBLYtvOuL8nceZL5WtuYnp6qipBF+fN0LkAJEYVZK4i5dqOORfuYbf0uUfHBb7yZvydnRoqfn1ElXsmMdB9KMLvmjC/iLdpOiU41NylW05YoW+HZesdFoXQ/5bfHPDt/rbdjVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=QrVqkLg4; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="QrVqkLg4"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 76AA74E4191B
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Nov 2025 14:44:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3F0876068C
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Nov 2025 14:44:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A50D5102F218C;
	Thu, 27 Nov 2025 15:44:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1764254662; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=xcSqTcn5tcxA4ggzs3ZGTYLGbD6hsPR/4kxcXx7YsIs=;
	b=QrVqkLg4s04OaaNRQRd323mVwsaQA7MdOdiBqDCtjSxSf2CAnkDwuMOdo21J5WjepPD26X
	R02FCCCkPu//nIx5MccgciIr6Y1JKx8V6uBzE20WsCM+sWJ8JYNg5RqAAnWGly5fBSRUOj
	aWb2TOdw8/bJihqP14SUdHTFnq0QWEIV84prr5FXaotVzDc8hJw84Ti1aC/S9Kpq+9Zht8
	OnHPahNwQFvOOF0iQU/pJI3leR4GtxxThfC6wUVszUkoRlRcO5j274EGwZl9rKsQ3UuZLE
	f9HlyzLvzgcOjKawkn/5OdM4s1BgJkdWGOR5p6SuHhHd9dcQHlKLHC3K5bextw==
Message-ID: <e0bda371-2452-44bc-9956-5f6fd4f42563@bootlin.com>
Date: Thu, 27 Nov 2025 15:44:21 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kbuffer: fix endianness flags for big-endian host
To: linux-trace-devel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20251104-fix-parse-v1-1-5af9b8965886@bootlin.com>
From: Bastien Curutchet <bastien.curutchet@bootlin.com>
Content-Language: en-US
In-Reply-To: <20251104-fix-parse-v1-1-5af9b8965886@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi all,


Gentle ping here, has anyone had the chance to take a look at it ?


Best regards,
Bastien

On 11/4/25 9:45 AM, Bastien Curutchet wrote:
> When KBUFFER_ENDIAN_SAME_AS_HOST is set on a big-endian host, the
> KBUFFER_FL_BIG_ENDIAN flag is added to the local flags variable instead
> of the kbuf->flags. Since the local flags variable has already been
> copied to kbuf->flags at that time, the KBUFFER_FL_BIG_ENDIAN flag is
> lost when we leave the function.
> 
> Add KBUFFER_FL_BIG_ENDIAN to the kbuf->flags when
> KBUFFER_ENDIAN_SAME_AS_HOST is used on a big-endian host.
> 
> Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
> Fixes: 5f2aa8497c5b ("libtraceevent kbuffer: Add SAME_AS_HOST for endian and size")
> ---
>   src/kbuffer-parse.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
> index 71291adf0860b8392e6cfa0b0640c6472def422c..232d1688934a946e19f52886c2d25e4c73637b4c 100644
> --- a/src/kbuffer-parse.c
> +++ b/src/kbuffer-parse.c
> @@ -247,7 +247,7 @@ kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
>   
>   	if (host_is_bigendian()) {
>   		if (endian == KBUFFER_ENDIAN_SAME_AS_HOST)
> -			flags |= KBUFFER_FL_BIG_ENDIAN;
> +			kbuf->flags |= KBUFFER_FL_BIG_ENDIAN;
>   		kbuf->flags |= KBUFFER_FL_HOST_BIG_ENDIAN;
>   	}
>   
> 
> ---
> base-commit: b3f5849527ae226b88342ef80fc42c66ab206f99
> change-id: 20251028-fix-parse-7395a8571b72
> 
> Best regards,
