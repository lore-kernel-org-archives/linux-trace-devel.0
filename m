Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4592C22069
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705857450; cv=none; b=DO8M4hAeRN+9ezwFfTfrGoNcdEehM5+D+gewuhqfslKdbmEEIwCgDZH3BHLle0oo5Cx/x1uagTc7QQaN8vYg1bGqBLlDpN2KFgkadtFHFZ3vst+mLkLvcKqe7pCecdmC+43WylLso/LRtsiJUTMs+8O2QCBItmViYZIVUj7vX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705857450; c=relaxed/simple;
	bh=LrgrA79ShebG2K/uqaAeU3tVZjyfb2NWz6sXlu4HoEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wfd9ccGVQGYrIUzrOHfXDLHS1ajz2vDWDVroOoaZrmEWqQmNqtEcWi2WoyxOIaiWuxqV9eay8hj9A2yLaforbjVLzVFbgYCRVyG6XJFUHLZ9ea2WBm+LrbnJjXJkj6j4w8gRgfOdDvKizpw1WMb2HcqQJDpT9nN2n9qixHrE/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1em8J9H; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1em8J9H"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2cdae52d355so21744651fa.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 09:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705857446; x=1706462246; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iCA0JzHPIYhsA8NfdyrwoJSeGpr+hj3JXCQMN5mDhxk=;
        b=h1em8J9H/Vt+tcm/QKUkKwAoyGjAGhtb4uHr9FUhZzUInoh6ZHbcGS5B8kkllTmzS5
         SVsDAjCMhRXFYcQqcne+wtQ03Na5JNneq7iS/qL4NviNiHWm2AUxiEoGWaRqRpoSBc5D
         Q7kv7LkIdAlUSTZOViX0cYMdDsej5EHXouMlWTUY279/jzlUeFmgOrLMIyLGIblchljH
         wOND40YAD4+1ShmlFSXe/ZOVcRIVQlJH4JNaxP0VFe1Y5lp+YSsBRYPOKUorzX5OihJy
         ieDNzQb9qlF6G4GXIRF4uskO+XEgVqHYW5i1jD5zW6ihRIKRAUTACmCFnQlW+iux2BLR
         zuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705857446; x=1706462246;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCA0JzHPIYhsA8NfdyrwoJSeGpr+hj3JXCQMN5mDhxk=;
        b=aFjnH3h8di3MmxmxGtHqHIDVAtuyEBgTh63/YryvRjqK4gAdNRBXJPz5DAYEx6ZrXm
         Dhe/GPSiLo1UB1OvdC8VsFMGL3tGejEKnczKvrnlJZJ1/sQQeW8ry3+jWvtDyp+rEzZ3
         hKvm2gj0JfZAugMSZxgJjvlgivgbcAoIBgyUfScatoS82pM5e1uZuPZPxe9NRgq6Ehap
         iQgF9+pdsfSzjYjreGRT12a98VSkhzZRvO0GIPTpsOS/XzeyLuAe2Vz2IoPekxa4xB4f
         eHEFaTf7hVFr+gM8sDhfObjR6CWP4xROe9daLpz2RN9A99h4UR8qgp/0na2hbn75UvOM
         cg4A==
X-Gm-Message-State: AOJu0YxR6GcrCu1hve37nKxZZqFYw0WYjo31p2LvUcvocLNt9o6wKHdp
	BHcphYCpaQQleCH67yxobiEJ+1AVqXRYgUBaMNX5RPOEWb4dWT/d
X-Google-Smtp-Source: AGHT+IHlSlA08MCn350iiS5c9gRFkaEdAUpvLQeZRxr7DbYSS1df4g7xKRPm1P1R84KMFCeImdo7Xg==
X-Received: by 2002:a2e:9182:0:b0:2cc:ec6e:de40 with SMTP id f2-20020a2e9182000000b002ccec6ede40mr987285ljg.86.1705857446120;
        Sun, 21 Jan 2024 09:17:26 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id p16-20020aa7cc90000000b00558a7d36956sm13075391edt.0.2024.01.21.09.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 09:17:25 -0800 (PST)
Message-ID: <8e64baa3-e08a-81d9-bcf6-2876859b7a6e@gmail.com>
Date: Sun, 21 Jan 2024 19:17:24 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 05/34] kernelshark: Prevent potential detach of QMap
 container
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-6-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-6-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:16, Benjamin ROBIN wrote:
> Use const_iterator instead. Fix range-loop-detach Clazy warning
> 

Please provide a better explanation of the problem you are trying
to solve with this patch.

Thanks!
Y.

> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> ---
>   src/KsGLWidget.cpp             | 5 +++--
>   src/plugins/KVMComboDialog.cpp | 6 ++++--
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
> index 9e3dac3..0a44e77 100644
> --- a/src/KsGLWidget.cpp
> +++ b/src/KsGLWidget.cpp
> @@ -137,9 +137,10 @@ void KsGLWidget::paintGL()
>   	/* Draw the time axis. */
>   	_drawAxisX(size);
>   
> -	for (auto const &stream: _graphs)
> -		for (auto const &g: stream)
> +	for (auto it = _graphs.cbegin(), end = _graphs.cend(); it != end; ++it) {
> +		for (auto const &g: it.value())
>   			g->draw(size);
> +	}
>   
>   	for (auto const &s: _shapes) {
>   		if (!s)
> diff --git a/src/plugins/KVMComboDialog.cpp b/src/plugins/KVMComboDialog.cpp
> index 2b95a53..6be68d4 100644
> --- a/src/plugins/KVMComboDialog.cpp
> +++ b/src/plugins/KVMComboDialog.cpp
> @@ -308,13 +308,15 @@ void KsComboPlotDialog::_applyPress()
>   	int nPlots(0);
>   
>   	_plotMap[guestId] = _streamCombos(guestId);
> -	for (auto const &stream: _plotMap)
> -		for (auto const &combo: stream) {
> +
> +	for (auto it = _plotMap.cbegin(), end = _plotMap.cend(); it != end; ++it) {
> +			for (auto const &combo: it.value()) {
>   			allCombosVec.append(2);
>   			combo[0] >> allCombosVec;
>   			combo[1] >> allCombosVec;
>   			++nPlots;
>   		}
> +	}
>   
>   	emit apply(nPlots, allCombosVec);
>   }
