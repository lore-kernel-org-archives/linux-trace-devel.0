Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426B01E49F
	for <linux-trace-devel@vger.kernel.org>; Sat, 28 Sep 2024 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727533962; cv=none; b=f/xCrXQp8UHhb3tf4ZC5DvkwnRAtqkiDmu6x0R/3MYuRK0mXmhru3l4HlQMMBVg8lUDLps7FX5qDAnyIt4towa9uFs2+S35f1tGs/oXEw8cC3B21+vvplJG4kjGNK5miCrbeTEAsnkbsabrbVR/dv7DnKwrDJQS8U9lvw8ai/sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727533962; c=relaxed/simple;
	bh=3c99v59dz4cEXmTZOiBnikZtFAZs6xRXe7TGK+KnXWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfRQnt7dhMV8tSIpSD7118Sp3W1mH7DadfV6uF/2X5KzAL22gS8T+j5Zduh19UjfqkI03hkfml2FdzEAU9HrcMSq0ic2JUsCz+Gd3A9AZJaPvreMq+/59SFB1hsrtErAFWqq+DhCcDXCAU/OMUzDZWuLdrIR1nigs7B5hRUdIVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7SpGRo+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7SpGRo+"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7a843bef98so407887166b.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 28 Sep 2024 07:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727533960; x=1728138760; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9R6oXchFIwC14Wz6K7bYkKVv5qwIbYc0snJn3wsmCuw=;
        b=R7SpGRo+sqU5CsCbqn8UaDez2l0pMspG9GYxXOM6DOBz6hIDgtlEpFM1L4x1FsswZD
         JXHNNyqPa8C/FFVS/+2+5otppmQc6qf/uYmz0hWX5h1aQNGR9eo6L8lJ0UkOjAZsif9J
         uwi/CbERl2NTMP52dPfdopwQUpwrIsS+yrI/lgY+0IytqszcX5U8lhMdUxluYGCIIYZB
         9LD+ysmuIZYEx29RsRA3ezd/doa3MprV/ZG2Y7CEhI0wRo/10727/M0JnqXrw6QaMkQk
         rk/84E9fbeCzSTSPsRFZzO3FXmemvb0ytrB+lxAkJqO6JrxPi0A6wHRxpv/6hddcW889
         FjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727533960; x=1728138760;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9R6oXchFIwC14Wz6K7bYkKVv5qwIbYc0snJn3wsmCuw=;
        b=p5OkMOgJIiUUJydiRYch8WJ611NnG1/RCctlJ6rKCo1L9VNFy1kyxcD7Ff8usAeig2
         fHszb0fT46kbj4U9rbaslvh69vngejEncEekBDJkIQP3/ZVJqZ1Sz8rtyEb/1oyk8FPW
         hH5oJS3qJZi7bDHT7KCVd6R6JpIreR5EXtEYNho91SEH+ZTylcZkHtmPv8wbnhFCEu8+
         6fiKUB+5HpE5msCDMJ7w1cGwht92C5o5mcwsM0dfR6503TH0GD292eEoqXIuR2OPVskD
         GAXCAbS58FPeNHApqMNKJbNzdVO6/CctG8XA6y1b1cPpnCSDpi3qBLC+cnqmTWadaUNS
         H0tA==
X-Gm-Message-State: AOJu0YwMpnyAY2eVg0K0Rt0GJ26lWgel14dvKyjZVcB6PdwhXDcCmEn4
	imxvrs7ni8oiH2YuhF+64Rt8j0xecyec/d+WcCaTcDUza8A4EIbUkFwz6w==
X-Google-Smtp-Source: AGHT+IFKDtp7XIpAC3LPGPT1g3g6Y/w6OSVFjDlWXhGBAIcm30qPoK7IqxvpK3wFNA0hMkNyLDk5IQ==
X-Received: by 2002:a17:906:4787:b0:a86:8953:e1fe with SMTP id a640c23a62f3a-a93c4a69b1fmr729649766b.47.1727533959341;
        Sat, 28 Sep 2024 07:32:39 -0700 (PDT)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2947a7asm254505866b.103.2024.09.28.07.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 07:32:38 -0700 (PDT)
Message-ID: <66ae1d0b-8c24-00aa-e89c-515c545ca40b@gmail.com>
Date: Sat, 28 Sep 2024 17:32:37 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernel-shark: Multi-thread the computaion of CPU graph
To: Libo Chen <libo.chen@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
References: <20240923090912.1261220-1-libo.chen@oracle.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240923090912.1261220-1-libo.chen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Libo,

I like the idea of the patch, however a bit of extra work is needed 
before merging it. See my comments in the code below.

On 9/23/24 12:09, Libo Chen wrote:
> Parallelize _newCPUGraph() calls to dramatically speed up
> graph rendering particularly for traces from very large systems.
> 
> OpenMP technically is a new dependency here, but it's so embedded
> with GCC toolchains, as long as your GCC is not older than v4.9,
> the libgomp library that comes with it will work.
> 
> Signed-off-by: Libo Chen <libo.chen@oracle.com>
> ---
>   CMakeLists.txt     |  5 +++++
>   src/KsGLWidget.cpp | 15 ++++++++++++++-
>   2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index c36d757..8dd9ff9 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -84,6 +84,11 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>   
> +find_package(OpenMP 3.2.5)
> +if (OPENMP_FOUND)
> +    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
> +    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")

The "if" must be closed.

> +
>   set(CMAKE_CXX_STANDARD 17)
>   set(CMAKE_CXX_STANDARD_REQUIRED ON)
>   set(CMAKE_CXX_EXTENSIONS OFF)
> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
> index 9311d98..00a1951 100644
> --- a/src/KsGLWidget.cpp
> +++ b/src/KsGLWidget.cpp
> @@ -13,6 +13,9 @@
>   #include <GL/glut.h>
>   #include <GL/gl.h>
>   
> +// OpenMP
> +#include <omp.h>
> +
>   // KernelShark
>   #include "libkshark-plugin.h"
>   #include "KsGLWidget.hpp"
> @@ -690,10 +693,20 @@ void KsGLWidget::_makeGraphs()
>   
>   	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
>   		sd = it.key();
> +		QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
> +		QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
> +
>   		/* Create CPU graphs according to the cpuList. */
>   		it.value()._cpuGraphs = {};
> +		omp_set_num_threads(omp_get_num_procs());

Not sure how setting the thread number works in opm, but I would guess 
that you have to do it just once. If this is the case, please move the 
the line above to the constructor. Note that _makeGraphs() gets executed 
almost every time you do something in the GUI (zoom, shift, select 
event, ...)

> +		#pragma omp parallel for
>   		for (auto const &cpu: it.value()._cpuList) {
> -			g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
> +			int idx = it.value()._cpuList.indexOf(cpu);
> +			cpuGraphs[idx] = _newCPUGraph(sd, cpu);
> +		}
> +		QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
> +		while (itCpuGraphs.hasNext()) {
> +			g = lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
>   			it.value()._cpuGraphs.append(g);
>   		}
>   

I wonder why you add this optimization only for the CPU graphs? Please 
do the same for the Task and Combo graphs as well.

Thanks!
Yordan
