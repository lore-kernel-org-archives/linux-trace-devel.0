Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB0C381CC
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705865839; cv=none; b=OAO2fw6ebTQyybNoTcQmlfpvcUI+FpEJ4JKdGCqzilG+tHsIzo2ylwrfM7EKqTu4vlOEHeY075d35a1ctbKKdL/P+mwMI5zwV89z5BUvW//aQRdSV/bv17YiHSsPHI0NUe8IMCNJL8k7TMP2wbKruDkgrjApbrSxejQn3aX+iow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705865839; c=relaxed/simple;
	bh=UodHKHyDfpJaBmO02MIPUoAzvFxu/L1mTnSXJrpF+so=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+PjanZsYIvravi+A9t3lYzzloMCYlF3jRZfYt+0lKOyPqNVEG48mbji2aswW9AFsSjLOsIxy8nmBJYFICsuUPLN4c+wZgQVNfcSZFOELfwamMz6zNDKJXBRFUkQoWn1hsE6Kv+kY5hfyjIne1cAmBMtV1Xa6U1UiA26rM5Ftbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bemvZaUa; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bemvZaUa"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a26fa294e56so242610866b.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 11:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705865836; x=1706470636; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8eLK8Je0RYeUsKm/Go73eQrjb5+G1yeBXDQuXZd+F2s=;
        b=bemvZaUanmXxhnhTa0vpB+j5nTwhb6rDKIXQRlUOUZ9idGe/AGV5Efej+eHHnyna45
         P3xPpPMpRksIE4jHJI0izpgvs03C6FPM/X+ifrON4apM4opNP2qJWS3gW5lwYrUK0rhp
         WuklYc73+2VahAuzI02qbQNpRxlFeAa4dXq7MOT/UvuBrgWaBuBA1xHfjClPyDB81L31
         cT3MUcFoLoKAuZmP2aReBtHkTPUYulA06Mmq7p27yME1pDzNRvER/a0xMxxUMA1Qq2y4
         P4V7V7CW/ZyRmA940+i2pWYgiA8jsKe1MUamurN8LVGJSkI7YGWSnZPWqhLaNK7BA3pQ
         wWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705865836; x=1706470636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8eLK8Je0RYeUsKm/Go73eQrjb5+G1yeBXDQuXZd+F2s=;
        b=Iw6+/EzxiJASmQK0gX3ZolHGhgeezsSGuxuKUoMlqsrU6WMLLLR10OetWcIMW50Vvt
         F+Db+g/B6mzc6nXX0XeRbS7IZ3HxfWfz+9ZcBt48kV8z1CxVu+vumMUZZwjzzghv+hvh
         OFbY575Hg4jGt1ZvVtUej74NFw/V0d31e9CkEgRcUyudGieTGlhzqGKtzbqsPLJ4YHfl
         i0tfyqvVELORDh8QtZVJjXIurTCFCD9zMzcVyM8u+h6YbfOWg9/jizuTtjuf8mkR2ctn
         kgsnPx0m4i588lM4d24jiAoCghh/0uop1NTSEDc+aDHozTkkPCpzeh3/zPh/CZGm+K+p
         d7AQ==
X-Gm-Message-State: AOJu0YxePlxbDmIkTxIeMrjc0DohEXr5G4z5x8rVYUxNZidhmxTtD7H+
	vlW/WuIzclGtH63Y8quWcTqNRmtlDaqtyjtDxO9h3ZVhVBy1vKlM6CE/FpWO
X-Google-Smtp-Source: AGHT+IGo+zxpQugiOKhUJzewJ8ieXimU5AidUM3gwfU8sbniOb6zIbhDRgRDvyc1+K7q8VUxoM9vmA==
X-Received: by 2002:a17:906:240f:b0:a2b:51fb:dade with SMTP id z15-20020a170906240f00b00a2b51fbdademr1607899eja.56.1705865836109;
        Sun, 21 Jan 2024 11:37:16 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id m23-20020a17090607d700b00a233efe6aa7sm12602469ejc.51.2024.01.21.11.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 11:37:15 -0800 (PST)
Message-ID: <00e30015-f34b-e80f-bea3-a49d743f9ae2@gmail.com>
Date: Sun, 21 Jan 2024 21:37:09 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 33/34] kernelshark: Allow to reduce a bit more the graph
 height
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-34-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-34-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:17, Benjamin ROBIN wrote:
> With this configuration, at least one core on the graph can be seen
Please provide a better explanation of the problem you are trying to
solve with this patch. It seems that you decrease the minimum height
of the widget. How is this going to make "at least one core on the
graph can be seen"?

And please make sure you signed all your patches.

Thanks!
Y.

> ---
>   src/KsTraceGraph.cpp | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
> index bc910c8..4599a12 100644
> --- a/src/KsTraceGraph.cpp
> +++ b/src/KsTraceGraph.cpp
> @@ -593,8 +593,8 @@ void KsTraceGraph::updateGeom()
>   	       _layout.contentsMargins().top() +
>   	       _layout.contentsMargins().bottom();
>   
> -	if (hMin > KS_GRAPH_HEIGHT * 8)
> -		hMin = KS_GRAPH_HEIGHT * 8;
> +	if (hMin > KS_GRAPH_HEIGHT * 6)
> +		hMin = KS_GRAPH_HEIGHT * 6;
>   
>   	setMinimumHeight(hMin);
>   
