Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D70202963
	for <linux-trace-devel@vger.kernel.org>; Mon, 27 Oct 2025 19:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761594475; cv=none; b=SuP5OK76qF5JE4cDBL7bAyK9tD72WHR9r2rVuultbKZ/xuqji/PfmJt+Ak6jS+cl3D+S8nYamyjR2Rd90montTT+plovC7r6KLJ0MWy/BA8LNZVbXudmF2PZIGM06Gmn64Y9puRj5/kO7wREjFKpfBV6Th1d7VL3w6guLozO0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761594475; c=relaxed/simple;
	bh=LpqtiVerMDsoSdoHOWg/0bClxjOFiEQObX7VPrKLzzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oa46lu/ThxkbeC0CSi2JdSj6dGysgolSdlgBqPWRwlXPjH1H21ofJyUljkfO7PoaBoOYH2EXK20j67EpgcF7aGekPoBNlTzOjPROPvNxI39A8GCm3r09gutKn4h9e+b3fHHJ/cSmfjTNzoOqEtRwiVFUyFStbhtDeC3lOOYN6GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nY/+amyv; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nY/+amyv"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b626a4cd9d6so1049807466b.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Oct 2025 12:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761594472; x=1762199272; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNLr5rPJkNASrfr/AfYWx0x3Tcfw9VkyB7Y0k36DT24=;
        b=nY/+amyvo15zFfDKcA78vlHpATt6bfH6W9Agl5GV9Y9PUiE/0dcchG3WO8UIyJo5ez
         KRBg3jT3tRa7GhNBYrKOdDFXPr3qUQpswA+5HTpMkMlUTzLTqSXYRt+Hoep/i7g4TW3D
         258iRKefRTw/cBtuvvXcnFMoEFHY646tVOddXWDT2lvvq1V6nY3h9BO+pHnu3mpttRI6
         N+eFdjvgxgKMGNBz0SF4DZRoZg9p7X59MRAg++3tBYprdplB5wIlR8UbqTLOJANKctIw
         jITM8cPFTF7Ij1P9bvcxuEbeaYAmGyg0Gz3+PqCuCh/rBZBS8P+mz/ch1lj94aI0L7X2
         JLhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761594472; x=1762199272;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNLr5rPJkNASrfr/AfYWx0x3Tcfw9VkyB7Y0k36DT24=;
        b=WU7Wtdxp6jwMZtqua4diRqHUX5GbnM2kuX5rHnX/nPQmlZ52tbFgsD6HxonE2N2cBB
         EuiCpjTayO4X9tqfihJZxg5EkyapCOSqPAl2aK78XoOrFshGej7EbcqsxYTsHreBeKog
         R4jxGKFGzk0ceQk8oxFCpitD5Azt/qZHy3+5qbYyTXNPi0IGRi6aEaz2NFsDJANsouX5
         QPQIOHmDJxZ7ZIUcBUpPWtQboJ0dCrI85Fv3D76yh/lZ/mmbuA71/7h20Xxo4pbzvKMI
         s6aGgfPIljYfyTqNVLh47l+TiKLhpVE6je0drJgLWIt4Slf9CT/nZuzqG7tFU+5lSlkk
         ukAA==
X-Forwarded-Encrypted: i=1; AJvYcCX0McDKb/QoTVPWa18e/XAfE6Ulc82KfDcSkkihWsVmePVWKeao1GyFuC700uuDrNj3QwTD+W6J9/atba63Jj442A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeNodEG7eA+X/gB818sjdkfXvZQLX+1A6pg958RdOYmmxMBUO/
	FFuMImYe+kJoJEQC9i10nW7cuLJqwX9xCDMhaNJZRqkC4tQDUDsUFazW
X-Gm-Gg: ASbGncu9PPW5b5HOav6e4EzVKUF+77jIoYdwwnpmklyhCKRvl4wkcoNKWfhFFlboQ9j
	1R+UPT2dW8riAiWkNFm5QWqfwM8r2Kzs9mogUwm2fOmxHV2JJsys4m+3bjmCuOQgc847VL9MAXj
	8jFPIjV82XGu70loZ3bsgp+crdjLr6FbA5zmXuZu8tS9Z+3AJDKJ8iRxvaQXmp76pWOL8DISOjd
	Q00D4mGlIxMlMjgU4xmCapLeyrSUcngWAhrXpnL8kyDiPJ+EY9e3l4Bl7q7mK6twPwjd9bA23m9
	yvdLR7ZVy/Ag4hZA/8penLYTLvB0xzhShjWKU8BO47otHIqKFrj31z2qqMVAepiAkn5rK5fIvkZ
	WuEvP+G1c2QB6nm1Gk+4CHEIMLZJpZoB4wCci7egqjZj2DEbhydRUSJHCVPrAOQl+Yh16EgBuBq
	qvP4sYlmvYqriY8j4o4aiUbJHB31iwHxW56UDMvXvm1dzhYA==
X-Google-Smtp-Source: AGHT+IGvXrHA7fpVlbK9YMsv48+2ldhIoFIjv+F2ZINp3rfFnc8ZzrP5VjF0KjYXThwRvHQuE39vfg==
X-Received: by 2002:a17:907:6e8d:b0:b6d:2682:8306 with SMTP id a640c23a62f3a-b6dba48822dmr107304366b.23.1761594471743;
        Mon, 27 Oct 2025 12:47:51 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853386d8sm843327666b.18.2025.10.27.12.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:47:51 -0700 (PDT)
Message-ID: <12ad8a1f-26fd-147b-3ec3-100ab2175964@gmail.com>
Date: Mon, 27 Oct 2025 21:47:49 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: generate header file in the build directory
Content-Language: en-US
To: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>,
 linux-trace-devel@vger.kernel.org
References: <a5350178-93c4-4aad-a503-a622704fe764.ref@yahoo.com>
 <a5350178-93c4-4aad-a503-a622704fe764@yahoo.com>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <a5350178-93c4-4aad-a503-a622704fe764@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan

On 10/24/25 22:58, Mircea Cirjaliu wrote:
> Mixing versioned and generated files will bloat git listings.
> Put KsCmakeDef.hpp together with the rest of the generated files.
> 
> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
> ---
>   CMakeLists.txt       | 4 ++--
>   build/cmake_clean.sh | 2 +-
>   src/CMakeLists.txt   | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 54ff97c..84215dd 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -129,7 +129,7 @@ else (CMAKE_BUILD_TYPE MATCHES Package)
>   endif (CMAKE_BUILD_TYPE MATCHES Package)
>   
>   include_directories(${KS_DIR}/src/
> -                    ${KS_DIR}/build/src/)
> +                    ${KS_DIR}/build/include/)
>   
>   message("")
>   message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
> @@ -163,7 +163,7 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
>   endif ()
>   
>   configure_file(${KS_DIR}/build/deff.h.cmake
> -               ${KS_DIR}/src/KsCmakeDef.hpp)
> +               ${KS_DIR}/build/include/KsCmakeDef.hpp)
>   
>   configure_file(${KS_DIR}/build/ks.desktop.cmake
>                  ${KS_DIR}/${KS_APP_NAME}.desktop)
> diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
> index 67afd6c..2c05d3e 100755
> --- a/build/cmake_clean.sh
> +++ b/build/cmake_clean.sh
> @@ -6,6 +6,7 @@ rm -f CTestTestfile.cmake
>   rm -f DartConfiguration.tcl
>   rm -rf CMakeFiles/
>   rm -rf src/
> +rm -rf include/
>   rm -rf examples/
>   rm -rf tests/
>   rm -rf Testing/
> @@ -14,7 +15,6 @@ rm -f ../lib/*
>   rm ../kernelshark.desktop
>   rm ../libkshark.pc
>   rm ../org.freedesktop.kshark-record.policy
> -rm -f ../src/KsCmakeDef.hpp
>   rm -f CMakeDoxyfile.in
>   rm -f CMakeDoxygenDefaults.cmake
>   rm -rf .qt/
> diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
> index 0643365..da31f8d 100644
> --- a/src/CMakeLists.txt
> +++ b/src/CMakeLists.txt
> @@ -71,7 +71,7 @@ if (OPENGL_FOUND)
>                     "${KS_DIR}/src/libkshark-plot.h"
>                     "${KS_DIR}/src/KsPlotTools.hpp"
>                     "${KS_DIR}/src/KsPlugins.hpp"
> -                  "${KS_DIR}/src/KsCmakeDef.hpp"
> +                  "${KS_DIR}/build/include/KsCmakeDef.hpp"
>               DESTINATION ${KS_INCLUDS_DESTINATION}
>                   COMPONENT libkshark-devel)
>   
