Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44602E3384
	for <linux-trace-devel@vger.kernel.org>; Sun, 23 Mar 2025 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742745690; cv=none; b=oLn3qi5TajJZ5DPsczEcp8UVgkof0Dlm8l6BaGRwIlc6w/4X9zPH6otUhfz6DoDX6+LkGLYjJojwARwFQSPRml7myUAd648ao9LXBuz0Noyw52fXXiC8A6DFfjUqy8/bHa9z3/LFoMQKeN74Cb37aY/bKRRrig4TGCYzBxKV75g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742745690; c=relaxed/simple;
	bh=9MrdSArga7BWC37z+humpW5KWNcOR8+gtA5waWyzNUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sd8ZOK8gCbDfTf7mQdGAuKqVfFqW7+3zrthGmtE7eQsTVYiGbegoLFtAvd3Cu4UvLhyVxjct63Shk47GJRnBREq4/U8jW94NgH6hKu7PZboq02+8mbPxR8RxhF1K48h/aowXy/gtz/J/HJMrPbgzvTAsJaCg90MyxTowYRiCfis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=klOuV0k+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klOuV0k+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so23477885e9.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 23 Mar 2025 09:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742745687; x=1743350487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lnpH2raHjJ9RpIc1O9qzj3jFfJDcJFfwJH+Nf/qHLAo=;
        b=klOuV0k+7aHslXo76Qk5UMGh48gnlro8ZsyICeBcixE7xEWwtRMZ0AyBTCRx2qVxLo
         cHv+EjJgUGGQZ8MoB4gfOgtO7du5F7WgN+wu1ltfNo9kJadW06yWMqx3FqCziwIMwMEB
         CimXdR4vBM1/Gqjme8ZjJHtLIDKxStbmN0anxP7iyNuE+2/Amcs/m/fwxKJUU11weWKD
         qnactnqZKLaJfPTKBaygrHjZ15/8XP0C+ry6m7QPh3cO3YN9XbWWiigLaJlZboZOuTX1
         xQ3mR5ej6YeM7E1g1clP44vJkKQeiDHLQF+RtfdoLjtEIjteYEqezrVNnQxAXSSEZCL4
         T31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742745687; x=1743350487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnpH2raHjJ9RpIc1O9qzj3jFfJDcJFfwJH+Nf/qHLAo=;
        b=U55TdPIQQAb+RBsTEy2HV6d3GB2o+6M7QkYK8uSB6nchmsBubPRXjEMfRmwF/BYylt
         3vQMiJuxES1LODo+ChwS3oZE33gAtC3EN6ULJu2bfzGSHDjsQtE1yt37/fSSY6uwASfz
         wwSJEroL+Ze5dEswFQXOEfavlFP/HTjtUYZ9PJUQHWWctnTdlE1F1xMbs/krbCUg64Jn
         soAm/FUI5qtLYKNCyF7tok7y7XZgt6lynihiEkKhTKkFzxU2sp8ymeUQzgJW74gqltlC
         32Tn4IZt30t60d1jgp6ADINdIyvGdB8jb2gbV27qcyVJPUSIRwcgLPMcSC8ylajPZsEM
         hhzA==
X-Gm-Message-State: AOJu0Yxa+J6HhIGL30or2O+ny4R3VU4wVFo5TShpiFS0ELfCPGGT9bo/
	sQ3DjBysKsFCBoTPjOdtybVWWbb3/jiVOUKcaSgvpen/dSTvIGLW
X-Gm-Gg: ASbGncsBQqehdZdDvnAImtWjVrworZ1Zab9ySyj0PneHHlAq79Gipzt+Kt/y2ZDHPjI
	ffIVIkuwVHkT5K/3I2TXfyP8eGQ1aZw6JhBi+Tc2qayTlhAhZ0vLANqo337TTuU4KGy/iSdAWwy
	4ocYOwJZTFXRYpygNjgC/Z+mFDjOiF14uv/fC1eauswWXUtsweRjC41Ernk9L8oqToDrYBpydCJ
	GOq1M9MQJHk4dZ89nFIbuc5I23DECtgk4oF3xJ3LjjoQ3g+5z8N/yfNcvIMyZd8CFQOqSNNLoxT
	NLZh6p8JxJlhiocskQBYhyEFscb/bUVcXzhCDZ57XG0aHA16k4j9zTcNIKHWre2CHzVTqjQLiF0
	=
X-Google-Smtp-Source: AGHT+IHWHBTZg0ySv/QX3myd0xD6sX+eE9H1i7cDpfU6Dyt9OGb5rTgSUWH+IbUn+OnBsnv7wBN6tQ==
X-Received: by 2002:a5d:59ae:0:b0:38f:503a:d93f with SMTP id ffacd0b85a97d-3997f9336f0mr9617167f8f.40.1742745686535;
        Sun, 23 Mar 2025 09:01:26 -0700 (PDT)
Received: from [192.168.0.107] (83-228-63-123.ip.btc-net.bg. [83.228.63.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fdbcfaasm89363425e9.35.2025.03.23.09.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 09:01:26 -0700 (PDT)
Message-ID: <435352f3-ee9b-f592-a474-f55fe09a78cf@gmail.com>
Date: Sun, 23 Mar 2025 18:01:24 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RESEND v2] kernel-shark: Multi-thread the computaion of
 stream/combo plots
To: Libo Chen <libo.chen@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
References: <20250314220719.1065523-1-libo.chen@oracle.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20250314220719.1065523-1-libo.chen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Libo,
Please see my comments below.

On 3/15/25 00:07, Libo Chen wrote:
> Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
> speed up graph rendering particularly for traces from very large systems.
> 
> OpenMP technically is a new dependency here, but it's part of GCC, so long
> as your GCC >= v4.9, the libgomp library will make the code compiled.
> 
> Signed-off-by: Libo Chen <libo.chen@oracle.com>
> ---
>   CMakeLists.txt     |  6 ++++++
>   src/KsGLWidget.cpp | 25 +++++++++++++++++++++++--
>   2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 988bfd6..7847177 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -84,6 +84,12 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
>   
> +find_package(OpenMP 3.2.5)
> +if (OPENMP_FOUND)
> +    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
> +    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
> +endif(OPENMP_FOUND)
> +
>   set(CMAKE_CXX_STANDARD 17)
>   set(CMAKE_CXX_STANDARD_REQUIRED ON)
>   set(CMAKE_CXX_EXTENSIONS OFF)
> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
> index 9311d98..004d64b 100644
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
> @@ -688,25 +691,43 @@ void KsGLWidget::_makeGraphs()
>   		return graph;
>   	};
>   
> +	omp_set_num_threads(omp_get_num_procs());
I think I already asked you to check if it is possible to move this to 
the constructor of the widget so that it is called just once. If there 
is some reason why this is not possible, at least provide some explanation.

>   	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
>   		sd = it.key();
> +		QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
> +		QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
> +
>   		/* Create CPU graphs according to the cpuList. */
>   		it.value()._cpuGraphs = {};
> +		#pragma omp parallel for
>   		for (auto const &cpu: it.value()._cpuList) {
> -			g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
> +			int idx = it.value()._cpuList.indexOf(cpu);

Maybe I do not understand what you want to do here, but this looks 
over-complicated to me. Isn't it equivalent to having simply

		for (size_t idx = 0; idx < nCpus; ++idx) {
	 		int cpu = it.value()._cpuList[idx];

The same comment applies for the other loop below.

> +			cpuGraphs[idx] = _newCPUGraph(sd, cpu);
> +		}
> +		QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
> +		while (itCpuGraphs.hasNext()) {
> +			g = lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
>   			it.value()._cpuGraphs.append(g);
>   		}
>   
>   		/* Create Task graphs according to the taskList. */
>   		it.value()._taskGraphs = {};
> +		#pragma omp parallel for
>   		for (auto const &pid: it.value()._taskList) {
> -			g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
> +			int idx = it.value()._taskList.indexOf(pid);
> +			taskGraphs[idx] = _newTaskGraph(sd, pid);
> +		}
> +		QVectorIterator<KsPlot::Graph *> itTaskGraphs(taskGraphs);
> +		while (itTaskGraphs.hasNext()) {
> +			g = lamAddGraph(sd, itTaskGraphs.next(), _vSpacing);
>   			it.value()._taskGraphs.append(g);
>   		}
> +
Please remove this empty line.

Beside those minor things, the patch looks good to me. Please address 
the comments and I will be happy to apply your patch.

Thanks for helping us improve KerrnelShark!

Cheers,
Yordan
>   	}
>   
>   	for (auto &c: _comboPlots) {
>   		int n = c.count();
> +		#pragma omp parallel for
>   		for (int i = 0; i < n; ++i) {
>   			sd = c[i]._streamId;
>   			if (c[i]._type & KSHARK_TASK_DRAW) {
