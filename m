Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EEF38397
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 19:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705866599; cv=none; b=OCtOrJP2KNSrEu2CarEp/Kqo+BndFB0w0FdtLw4+f9OhjUHC3J+b1/+hNTrG4UR7YHrsm9Mr+vKRCA6Z5SpuFZohzOCIo3jHV94vgrQ/Boe7TFzgj5ldYfWXQs5zrGAw2H6deyWbzJYbadB0d83v5wYnOmIkXRXYuv4y25UIStQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705866599; c=relaxed/simple;
	bh=sEPkS2QBvcFupp01BYDAYOI//zcQh3JgRd1Gt5ox5aI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=f/tyjn6k0tcVtKJ3q2MPb22f6rVLdIuWRADKOvVEcEx+QmY87vSAsyfhFw67B/dV1zZGMrbdFhYtOQrUFHJwXtO8Vv6lreSDQOFNlPjLmW5+llJjXuqSeHJgL5fLuCSEJYAhpHy7T/wl0aNy717VapJj205a44/yyX/AIdm1QQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6geWYv/; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6geWYv/"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-559cef15db5so6379297a12.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 11:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705866596; x=1706471396; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nzee3EjO1rDmJqIZ/Fnri6ledPPjSVyaGvGd04sridg=;
        b=T6geWYv/nlvmozDDqZRcEKe2TmuSmZkE1RCNIPPcQyUBgUVunJIIyPwIiTzHXxhcoG
         moX1gE+hDU1/bORN8kvf0r5KGUcyHvPDMI+aKzXdxlDrFEdn4/wd2/Kv32AxUdkRH+6v
         MAoudnlB5KESD7sRJbLzclqEUzezG81+W4wR2TDIyspLgQI1msxGhIf99Yl2bIzGmGLc
         rzMbRkZr0orr4fdipusFDmIlIym85jO5p9eu+ozTu6JicPJUlpsI1ox0uSDPVWKbc5uP
         YuUlN9lpeylYfCAQx4QZOxGSt4ZkaAU3Di9jdVJOIOMd2y/sjSQu65UQgSb01kzR/S0p
         nNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705866596; x=1706471396;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzee3EjO1rDmJqIZ/Fnri6ledPPjSVyaGvGd04sridg=;
        b=VjnoTpDrgt6CsIabEpl/NP8wJD02AiZTXCCypwUtmKKDf0sbLHGIB7j17idoZJkh1f
         IsL4Wmw+odvLpKmrikRHTu1GJBhd1imuZaOvjya0URkB/IQYZDVMqVO4acipk+r1JFgr
         m5lzbQWRcHY0cFZcmX2vOwboVHyOLGeTqsfVo08DZQZ56j7eVL1nA11d70ig8FZmgSE7
         EqAGHSuRwcH9dQIqSzHR/Gp/JPRb8DjrZRnVWhPR04fIlKYtKKINSwOwJ3xyRuHzJeLe
         zUJmSM2w7+NHbXn6/mROv3/EuO6fnz+Md+mqJ8eV5mrosRwWDed2Ynb9Da3ZcEj9ewm2
         dSEQ==
X-Gm-Message-State: AOJu0Yxfqtu7npyTR0kaNgaKlWQWW/BjOV5tqqn0vKn1zImmKSDaxOkc
	ji+LiSJGMZjkOGeyvw3j4AlHcLRiShoxIZ9qxFMPw5NENNnGOKeWELXScdbw
X-Google-Smtp-Source: AGHT+IFhuOAXGqY2Z7Uq4lGN11m16goqCscW8hWtoitOMyz23lmZWXPgvRZ8mKeY6sGxfxI3UbvYKQ==
X-Received: by 2002:a17:907:1011:b0:a2e:948f:2665 with SMTP id ox17-20020a170907101100b00a2e948f2665mr3087280ejb.50.1705866595691;
        Sun, 21 Jan 2024 11:49:55 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id cw8-20020a170907160800b00a2cd72af9cesm11487819ejd.146.2024.01.21.11.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 11:49:55 -0800 (PST)
Message-ID: <b6f83022-36f2-1115-2221-25f77be26332@gmail.com>
Date: Sun, 21 Jan 2024 21:49:53 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH 11/34] kernelshark: Prevent potential divide by zero in
 Shape::center()
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-12-dev@benjarobin.fr>
Content-Language: en-US
In-Reply-To: <20240114171723.14092-12-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:17, Benjamin ROBIN wrote:
> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> ---
>   src/KsPlotTools.cpp | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
> index 1d63a9b..8011329 100644
> --- a/src/KsPlotTools.cpp
> +++ b/src/KsPlotTools.cpp
> @@ -318,13 +318,15 @@ ksplot_point Shape::center() const
>   {
>   	ksplot_point c = {0, 0};
>   
> -	for (size_t i = 0; i < _nPoints; ++i) {
> -		c.x += _points[i].x;
> -		c.y += _points[i].y;
> -	}
> +	if (_nPoints > 0) {

Can we just have

if (_nPoints == 0)
	return c;


Thanks,
Y.

> +		for (size_t i = 0; i < _nPoints; ++i) {
> +			c.x += _points[i].x;
> +			c.y += _points[i].y;
> +		}
>   
> -	c.x /= _nPoints;
> -	c.y /= _nPoints;
> +		c.x /= _nPoints;
> +		c.y /= _nPoints;
> +	}
>   
>   	return c;
>   }
