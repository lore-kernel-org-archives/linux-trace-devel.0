Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF58119ABD4
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Apr 2025 17:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743701737; cv=none; b=h7aS3ywjBEWC09zyUulmffVHpQTYUIhGcsKWZacw0upvu+NhY+lVOlwal6Zb3mCMmwn+ps3D/OsLnkZnHO0iwAo68+ZqzkGhE9pOduzeR4wwJK1aAEUcPGjKXCpOqKkeEgR2MD2WPt5GAkIIJTk1FSXjt7130Z0u9KQOcT94drU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743701737; c=relaxed/simple;
	bh=kU3chiQMtLw4Ewijb6//EiNc1pBxUeMTs6ROcMUU6Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nutnvynIW5PHgc38rQgGUcnT+P9zWlw5tRc/3VFazKMl5uP1CpJP1Dc9fgrWnoeFJihP2cMDqB8NidHVDdJEA1UrjmWgexJmt9gtFpwEBJxwIuGmIkGWMP7A9QVsA742lDdw+tRcWTHFVMgdpcaIywhcG7B2Q8Zl9i++MuELGfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XzaJU8hv; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzaJU8hv"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso7679185e9.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Apr 2025 10:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743701733; x=1744306533; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rhzKKJXBgb1TBIoFe7QKSNj6y3DYctsVlZae2Uegqx0=;
        b=XzaJU8hvuHsU1upBSY7Imv0HHsp+fXPdCXYqxGCwtgqQmsPmGz5dnmfOmeGxHsibBN
         TskoQREn1YAwDtG7V/jn4dZw6RUy/OwUeUVF19Wu2sPtz/BjxKAEHvH+WQjuMpupQQsb
         v1D06RnPhARIHxpARj858j0HY8fY/YG9+69EpFQLN7LEg9Ct+qR2WHeWV4ZSsgPW8NbE
         vH4X0ODLONzieexkYz8Wce9dlsFU+2682AYeBHH6Gulh2urNrgIkLIS1CCR/bysmfIRm
         O84KfHUKygbWclk8xccp5VnC5Z+leVVYBOTP0TYzTtREpp/oNSzVD8TSt805m2L3wK8h
         8L3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743701733; x=1744306533;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhzKKJXBgb1TBIoFe7QKSNj6y3DYctsVlZae2Uegqx0=;
        b=ci0OAdqz+zDnnkLOJKxEsoZUf0Rk3BEbVr1hPfhiAAznWDhXZ/wTDCHmMFuJ5TCmec
         8PFVyjwbRLEEHLx1p7bkMsXqgpa6dH4qSpLijNBhUusluIkKpnk+Xm+g3ysQUYb8kvNJ
         wnEjaGc01jEWSCdkwQn8DGYnC6bJdcua7WsFlL3XM1rbAjL2gIBuDm/XHHlhgKlzfRXG
         K9HWCYjZY1p6DcHErV08w2k/YQTJpd8ZWUyc4QMZdfcgddSvJVhZv0YNdHeDM6tzxw3g
         RmWWwBQgINyO0CfFL6ujgOh0IAoLCR9Y7eB1DlxgKVd03O3L62GN3cpGi1rUbDG4hBt6
         Svqg==
X-Gm-Message-State: AOJu0YylaVWP8C7gxo1J0vi1tQP3AnpjcYDQfB4g6Fof0bStMh4zHB+A
	TUO9UgjTS+zCFyl5jAkQ6J0tdSUlm7ruGS+KywgnnVRhPHGTGQW+
X-Gm-Gg: ASbGnctI+zc+p93LRg0s/CvelALcuiFqqQMhuPpu4WCQHKYkR78U0dRcgAtX6NqAEEf
	SR6FSGeoutmaeyOQ6gUlcpjfmnp4m09VRMCpI3hjANF3/xYNYxnKz6MjIZJc1IqZclF2KVMDZr7
	sci89Nj9Z3IOC3kYj3X15U5+vvz/7EuzUMjTG1hqx4gDUwuA6jGkzq5Ufp3lXRLG4DFclyzaKzX
	RW4Xg+nUXbbqZaShfwU4b2nwT7Go4a6YsQrA632OaP1Vauc/cAb7xvWL5+NkylROsZVSN5gZi01
	KE6huB/1BqxUfKHxBm62EszUBZ/kRNZ/6pv5/xdbSAIl5X9mge1L/Y7+UGT1kL6tcucc5D/wY3Y
	=
X-Google-Smtp-Source: AGHT+IEXVNDkb/52ahY7iLo/XYVOiwBAzv9wii66ftxibDb0F/PSMvrhFgJaXWffn4bIh4oWak/u2A==
X-Received: by 2002:a05:6000:2506:b0:390:df75:ddc4 with SMTP id ffacd0b85a97d-39cba93377bmr178933f8f.44.1743701732679;
        Thu, 03 Apr 2025 10:35:32 -0700 (PDT)
Received: from [192.168.0.107] (83-228-63-123.ip.btc-net.bg. [83.228.63.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c30096923sm2378358f8f.17.2025.04.03.10.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 10:35:32 -0700 (PDT)
Message-ID: <b93c9ce3-673c-7e2c-adb2-b9fa735ffbff@gmail.com>
Date: Thu, 3 Apr 2025 20:35:30 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3] kernel-shark: Multi-thread the computaion of
 stream/combo plots
To: Libo Chen <libo.chen@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
References: <20250327002133.135719-1-libo.chen@oracle.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20250327002133.135719-1-libo.chen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan

On 3/27/25 02:21, Libo Chen wrote:
> Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
> speed up graph rendering particularly for traces from very large systems.
> 
> OpenMP technically is a new dependency here, but it's part of GCC, so long
> as your GCC >= v4.9, the libgomp library will make the code compiled.
> 
> Signed-off-by: Libo Chen <libo.chen@oracle.com>
> ---
>   CMakeLists.txt     |  6 ++++++
>   src/KsGLWidget.cpp | 30 ++++++++++++++++++++++++++----
>   2 files changed, 32 insertions(+), 4 deletions(-)
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
> index 9311d98..7f2001c 100644
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
> @@ -54,6 +57,7 @@ KsGLWidget::KsGLWidget(QWidget *parent)
>   
>   	connect(&_model,	&QAbstractTableModel::modelReset,
>   		this,		qOverload<>(&KsGLWidget::update));
> +	omp_set_num_threads(omp_get_num_procs());
>   }
>   
>   void KsGLWidget::_freeGraphs()
> @@ -690,23 +694,41 @@ void KsGLWidget::_makeGraphs()
>   
>   	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
>   		sd = it.key();
> +		size_t nCpus = it.value()._cpuList.count();
> +		size_t nTasks = it.value()._taskList.count();
> +		QVector<KsPlot::Graph *> cpuGraphs(nCpus);
> +		QVector<KsPlot::Graph *> taskGraphs(nTasks);
> +
>   		/* Create CPU graphs according to the cpuList. */
>   		it.value()._cpuGraphs = {};
> -		for (auto const &cpu: it.value()._cpuList) {
> -			g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
> +		#pragma omp parallel for
> +		for (size_t idx = 0; idx < nCpus; ++idx) {
> +			int cpu = it.value()._cpuList[idx];
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
> -		for (auto const &pid: it.value()._taskList) {
> -			g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
> +		#pragma omp parallel for
> +		for (size_t idx = 0; idx < nTasks; ++idx) {
> +			int pid = it.value()._taskList[idx];
> +			taskGraphs[idx] = _newTaskGraph(sd, pid);
> +		}
> +		QVectorIterator<KsPlot::Graph *> itTaskGraphs(taskGraphs);
> +		while (itTaskGraphs.hasNext()) {
> +			g = lamAddGraph(sd, itTaskGraphs.next(), _vSpacing);
>   			it.value()._taskGraphs.append(g);
>   		}
>   	}
>   
>   	for (auto &c: _comboPlots) {
>   		int n = c.count();
> +		#pragma omp parallel for
>   		for (int i = 0; i < n; ++i) {
>   			sd = c[i]._streamId;
>   			if (c[i]._type & KSHARK_TASK_DRAW) {
