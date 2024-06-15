Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70819D89A
	for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jun 2024 05:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718430634; cv=none; b=mi/FnKLfyEVNGLAHMUYWcCcXiQ6rfphLKs9b8b++tFuS7ZceyrBfr70Z8SKl6IUxd6VW4R09gCTjPuNdUUQDEH/yS3pNOmWAKOrgMZxGtfUvsMvsFOZrVUim3ZkZQmD8TRlQPPtB8s+iW8NstlJZBYUZnJ6LVY/1VgsbG3jNrqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718430634; c=relaxed/simple;
	bh=+VODBeSuDXH0RXnpQp6aaKxnhEnDsRQjGW6nOjzfWgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=caoFDvCn7kShlhf7g144DWl27gQ+UrwHYmhEcxZYO3Y4TAYR3pDOVZqKoSHhSMWQdG8yuypHH+O/VtWzTpxGXYCyyGt3QL36lzoAQ2cWl2mWtffOHHuT/Qhyq+0mkzCUyV+D60ncZ8lCQe0Vrv0n3V3u8hWKpXEkxiUYdUUMQP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKicJQRF; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKicJQRF"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ebdfe26242so31612361fa.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jun 2024 22:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718430631; x=1719035431; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r9dXt2/XksO76MhudXHGDlCJAC5hWkb+rf4iErT8jXY=;
        b=HKicJQRFohTcwWjTl0WgWmH+DbYBkLchLCZTT9Sy86nG1xtkBm+YNyiv0mx/lyjKeZ
         SOO+mo1lqahh2zGVhYf7d+WNo5JtihF6tn8cmpaivY2Vjm9+A3McetPW7+XsuUIERA/h
         e1HrVXexLxUJdaVCFNQ6LSBBlBNh9Pgaz+W7RIg+QgSGrlez61sBylfvOWA7BnAI+7Do
         Db3CxaNLAEB+FWiHEFZwVzBLs7xBiogfQxU1q0OrBTdgIyDxnvvdalFonOdw3eqCf7J6
         U9JfI0TZRT1SD9K4h1Z5LqS6rxH3YAUbOu3cTE9uMxoxDiYBSJA4DFINLd9/n+kVHScT
         yi+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718430631; x=1719035431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r9dXt2/XksO76MhudXHGDlCJAC5hWkb+rf4iErT8jXY=;
        b=X1SBP4kGuPRb2QNCZexcqjrVT9MunG5kayNYh2wAMHczhfC7OcmB+WJCF4AdJZC5w9
         Hn4IYbrl8mkXpAa4GapVM6fqtN5wD4U00LVzCLq6ppSpxZ/HZcXrbnSAVzcgdA+0Pq07
         q9sLQx6rvNEo4ykWgzTX+k5Q1hE1p3iKCwxqgvLSoxDsDu3VbyvOwc0PgG3pc65Uuj43
         yCqGhgumv4XXbVfISq3E6tCo2p0ja2iLwi1hJXrBFOdpwreVLmZ/M2r31uRCQjGJV8/+
         g2OMAAC3OZC2/LmL6rTTlhUd8vKo43Co7r0giWFjmCeZd7LkQGSGH5zQ67My/Qxf7K9e
         TY1g==
X-Gm-Message-State: AOJu0YzdADP+fdtjKWvHFBF3X+6GXE2zny/WeiwkD9TmwJjc1g6rM+Pz
	7wNFOMnekWnmmp01CZTISY1xi4c+vDtygd/YYcq0umy4IEep1RIXSE463A==
X-Google-Smtp-Source: AGHT+IE3n8WppNJ296an74i+tWAvX1ybn8S2rg6j71TjVgHlOVkDRZmIy/W9t/4PKuTtPPMziylXpg==
X-Received: by 2002:a2e:9015:0:b0:2eb:f9d6:1bf9 with SMTP id 38308e7fff4ca-2ec0e47a176mr31156941fa.23.1718430630493;
        Fri, 14 Jun 2024 22:50:30 -0700 (PDT)
Received: from [192.168.0.107] (78-154-14-69.ip.btc-net.bg. [78.154.14.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075093a13sm6214139f8f.9.2024.06.14.22.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 22:50:30 -0700 (PDT)
Message-ID: <875a00be-1967-167d-e87d-67a53b82ecae@gmail.com>
Date: Sat, 15 Jun 2024 08:50:28 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: fix compiling error in LatencyPlot.cpp
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240611153334.103780-1-jmarchan@redhat.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240611153334.103780-1-jmarchan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan

On 6/11/24 18:33, Jerome Marchand wrote:
> Include the <algorithm> header to use std::for_each.
> 
> Fixes the following compilation error:
> kernel-shark/src/plugins/LatencyPlot.cpp: In function void draw_latency(kshark_cpp_argv*, int, int, int):
> kernel-shark/src/plugins/LatencyPlot.cpp:306:14: error: for_each is not a member of std
>    306 |         std::for_each(range.first, range.second, lamPlotLat);
>        |              ^~~~~~~~
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>   src/plugins/LatencyPlot.cpp | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/src/plugins/LatencyPlot.cpp b/src/plugins/LatencyPlot.cpp
> index d412917..5e3393b 100644
> --- a/src/plugins/LatencyPlot.cpp
> +++ b/src/plugins/LatencyPlot.cpp
> @@ -15,6 +15,7 @@
>   // C++
>   #include <unordered_map>
>   #include <iostream>
> +#include <algorithm>
>   
>   // KernelShark
>   #include "plugins/latency_plot.h"
