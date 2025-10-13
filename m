Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1272D30F7FA
	for <linux-trace-devel@vger.kernel.org>; Mon, 13 Oct 2025 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370936; cv=none; b=bbqiQBIemFSH0ZVlBIrah5AhW3NE3A8cowSykQODl14Z2mqVQEwFCkVCLCFCz27l2NMWIgcezYnflL24a1XBprP5k/R8PnNR3K+l+qFrlEglVV9c0sRWZgKVPVuT4DgccD+jXiayRJsZMVDj6crgsnoh1ehQVy3nRY4uosQBgzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370936; c=relaxed/simple;
	bh=KhLgxZOknUU27id2+JpjyZAh5hfeg0/PBunTJRcSi/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VzWjn9VBkb/oHUQGPDBmnaak8fCVfnoEfrkf+kJloYCkHmxpEe1or0Xvf66XKgacN3Pm/9EvyNdQdJsetVCfzdf+t/LRL25nrxm6un4WiJzxJpWWQcpQlZrH4GBmIVQE44AwazmAjbXP64edg5Ivnc6PaEC2qruq2FOl+fPmxxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G96NksvA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G96NksvA"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-637dbabdb32so8606478a12.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Oct 2025 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760370933; x=1760975733; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FZ2KU8GuydlzfTEkImEA8OepYDWFSXcKlQCD65AaaZs=;
        b=G96NksvAkzMgxfo5zkLI2u8SoVm9rV++dI66+pDeXBgdsZcSb8LM7sZxK2WOjjgVBU
         9l+6Ae/BGCk5LX0r7EzRxnCGmUFrO/4yuRC45EI7axWDzULu/iZGbqluqU9ppkqNO4rE
         Nk5LDY55P4Xu9AlUGX00fDpypcByvsGsuGJHF5SRn7WD87DBwmon63yMn7CtmkkUFPAG
         KacfC2gmbFdX3O4smTMAKQ1+z76KyouPP8UULvPl25wB5Bx5HyCJZDs5XZJtkjOSdMtK
         VmQVYZvLI+R+KRZgyn9acJLutbtg481SaSopcmtJZWE5lw6nIB+nu3u8wj5tZYWETcWX
         FOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760370933; x=1760975733;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ2KU8GuydlzfTEkImEA8OepYDWFSXcKlQCD65AaaZs=;
        b=SNtf0aH5UyGZ1RpGBJPvp7I7CCsQLpFd/HtccIZ2RcX4/uoypM25Oraa9JCcqTH5wH
         WhWzbsO2FNASnLpSjVjMbXqrJ2I7O4sT28XZzdKMHmu/J/OzebsMUZNIBPJYFYGgV0tl
         lGXHs/bcUj/aSiehtfkS0VPPDeoOMA8qoKjwip/NWInygB1Qn6DAa93Mbw/uOb89NPkU
         PD1K5TPhfTbJoC/K2JSbR2cH+mPINyhZw5NZl5MPTPaZzBjm2yjm6b995ZzumVD1UoPp
         25hb/Zs7KXs8ONIr7+gHBW0eFgziEgZThCJAd/Vc/iCE4n4uNvItifnCcVAPAwE2U5QG
         zjQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm6fz7YtkxITJFUf99ek0ToBx7BL+FiygggD31KisVa5h+QCkJ/EiZaWP2I3X/b7D25SEodIdrhmcEXlwG9a3FIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHrhHDlAVbYnHndsaHUNQw+ZboC6FHp+l7WXTtYZ78XdIyn7Ht
	vazWgtPzZq6Ra6QYODykK6hGbHqukb55BK3j1CZQoWJbrrsMEJWaniDUH4y4lQ==
X-Gm-Gg: ASbGnctkPJlfQwuWeKtS8onCPIdDB7zvkwhB6DgnJhk9ZUglppQ9Do2FWbJgAw4rwmQ
	3SfVOsHUyxE+GAXoo+lqhOpNIdF1x+7zLwJ/rq2lFwKtva/DrhDzeBwHneJ54hnvyNRCepr1ZMk
	xOWy/zkJ6EUdcUq1yr10w6hLuaKd1WKiT6bBQxpidXlpG1xMUQRsudyPLUaqWQkIbpyqCs/4fPn
	sOkkLdfuHi38p4AbeP6+LLhC0t9BMkVlgwj1Zqa1XY8WE/Ti/xl9J+VwQlJjGd8iBG+j3Y0s9Qd
	6nWcLEpvjAeyEovO6jrUe/oPGwL4Fu0Qdact11R0Ubshh42cNo77KgXBIathAT+9fxGrFHNZ7fn
	t1SKWHNT4PZE42i2zp56V9FTnwz11gpPB11phvnM3M+Z2nfxZnWjEkV5I1jRoQXZXVw==
X-Google-Smtp-Source: AGHT+IH4Ak2/38QUcqKuMqck/VAyLe3ny+dVIiD6XehMUI2xfzNlt4vFWk1FF2utbOeZoq8jv07WRg==
X-Received: by 2002:a05:6402:278e:b0:639:e11d:650d with SMTP id 4fb4d7f45d1cf-639e11d6e63mr17601601a12.14.1760370933114;
        Mon, 13 Oct 2025 08:55:33 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a52b10072sm9019547a12.16.2025.10.13.08.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 08:55:32 -0700 (PDT)
Message-ID: <7adea1bf-facd-7967-18fc-8021b2d7253f@gmail.com>
Date: Mon, 13 Oct 2025 18:55:31 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: Allow building with CMake 4+
Content-Language: en-US
To: Michal Sojka <michal.sojka@cvut.cz>, linux-trace-devel@vger.kernel.org
References: <20251010131715.1123934-1-michal.sojka@cvut.cz>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20251010131715.1123934-1-michal.sojka@cvut.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan

On 10/10/25 16:17, Michal Sojka wrote:
> CMake 4.0 removed compatibility with versions of CMake older than 3.5
> [1]. In order to builde Kernelshark with CMake 4, at least version 3.5
> needs to be declared. However, versions older than 3.10 are deprecated
> so it's probably better to upgrade directly to 3.10.
> 
> To support builds with older CMake, as before, we use the "..." syntax
> in cmake_minimum_required [3].
> 
> [1]: https://cmake.org/cmake/help/latest/release/4.0.html#deprecated-and-removed-features
> [2]: https://cmake.org/cmake/help/latest/release/3.31.html#deprecated-and-removed-features
> [3]: https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html#command:cmake_minimum_required
> 
> Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
> ---
>   CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 6aa1a5b..54ff97c 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -1,5 +1,5 @@
>   # Check if cmake has the required version
> -cmake_minimum_required(VERSION 3.1.2 FATAL_ERROR)
> +cmake_minimum_required(VERSION 3.1.2...3.10)
>   
>   # Set the name and version of the project
>   project(kernel-shark)
