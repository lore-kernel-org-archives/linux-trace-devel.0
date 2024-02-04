Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1672561C
	for <linux-trace-devel@vger.kernel.org>; Sun,  4 Feb 2024 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707071685; cv=none; b=HCalT7KwrL8n3hrhlcaV8Vsg/stZ4uJwt4xGzf2qZUcjQJnIuQI6EjlJSmCqX8eg/i4U4i9WzcLDikRKW5e33T/thmETWL2SnQLb8Vsv43bdVjVD/SJGS8aIrV7LP8g/q0FAFCAYZ7j+TfARR7gYB/vs1ysUaJPOv/wSJcyJnC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707071685; c=relaxed/simple;
	bh=dkyNAEnt6u3BZ2qF8ZwU86kLjJsQsN3nwGOQPtwwjyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1cE8IWnNY+5HZj4ZU9WYa806UMuH56Vl7rJG3bom6bHAboGxHmnxT/gT7cQNJjK0lqegGNBc1s0zgouDQutG/w6mseB+Xqwe2+BoHeeZZKc0AuX9CuV6gwgnM2p8JwI4lLwkLRYJ7FnI4A54XcxvHz+v+rcX1QqgX72G35ipts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQ6iYTef; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQ6iYTef"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a349ed467d9so440432566b.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 04 Feb 2024 10:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707071682; x=1707676482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mdqDw8L8vHwAxA0eokjieFBTa5Bj+Ua+6ilSNqzWh1s=;
        b=MQ6iYTef0tOxP2hEhPxU/JMwLXZmut0RK+tGV9W+oV7lE7smCCSIkuWKtR4fMln2x+
         3MDH9YK5vDMlXWPKKsVRbVpds/WdkziJEWl/0r1TYHaOHB6BRUz6COjWo5JPEDKTFKj8
         H0/8f+Gq8yaH8J2A568VupKYlfcqdJLkHPwfYn+9k798Bl2KQbLNR2ijaodSQn7VkaIF
         Lo76m4EE1nXJr008eQ+OwV6eWpUmcX/2mOfiKYBrIwWXaGV3jJFlA7UkOVqi2I2SV8Xs
         uByY+3ieNBdZ6JqRdav2kdCsEBV6V4GNLhY41JjktymT8pd0iermh/cp/V2Xrv+B/ryN
         Byog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707071682; x=1707676482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mdqDw8L8vHwAxA0eokjieFBTa5Bj+Ua+6ilSNqzWh1s=;
        b=clgPid+VG3V3rvlfikkQd2L4SoHPJJ5PwoMdj4Xfw5EEXkYAM5um+E/k0wIsnVotxl
         J4Gn55bbSulRe4+tFeY9zpy8uRlbIj7q+Wx0U5bBjHglF3lB5BKA2noDyFGLUXnALLDK
         2FWVTkjMX4lWJ2ybfuk6UzgWvXwfU7HjynEmiP+Kn52WqeScaggYIqujn9rg1uIID0Gt
         1KHpK8nZ98blv61sb2J/eAUgFedt2Agjc4ddb2nLT2FM292vOlubSN6hoCP7CuGJRqZR
         t/yyZEBMB4mi66Z6o+jRpv5GHtUVkqKYvbU9tUIXE/6R8ZyWZd0m0GX4VsqCK3EUzmZv
         NHSQ==
X-Gm-Message-State: AOJu0YxwWfRNMWaJLsrV9Bpyjno2QyIvG6QEwNQTJ685v9NPf5N1YNEh
	p7AkWaXzI2Z0xWjzPhqWSnyz7/DxK4tsCSGFoM6N4bRH6eHX/od0EGh6dnkU
X-Google-Smtp-Source: AGHT+IHgVOFqyON/BCgqs2sF1x8epPIvLjjXyWHDPIVGKGbyoipkDHtA4Ka+uq/AZF6oMlj4Q9X3Tg==
X-Received: by 2002:a17:906:19c4:b0:a30:fba8:8fe1 with SMTP id h4-20020a17090619c400b00a30fba88fe1mr5364539ejd.21.1707071681768;
        Sun, 04 Feb 2024 10:34:41 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id cx10-20020a170907168a00b00a367bdce1fcsm3409147ejd.64.2024.02.04.10.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Feb 2024 10:34:41 -0800 (PST)
Message-ID: <bc2f74e7-6e1b-7f2e-40e0-b40c842a7bb4@gmail.com>
Date: Sun, 4 Feb 2024 20:34:39 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 04/34] kernelshark: Do not create a temporary container
 for looping over QMap
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-5-dev@benjarobin.fr>
 <56c65e9b-7536-3246-5250-7a68e36daa36@gmail.com>
 <7uyekhxkszucdofjsa23gqs4utdspx5u3vlhili6p72stbebux@djht53oakfff>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <7uyekhxkszucdofjsa23gqs4utdspx5u3vlhili6p72stbebux@djht53oakfff>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/28/24 22:30, Benjamin ROBIN wrote:
> On Sun, Jan 21, 2024 at 07:16:01PM +0200, Yordan Karadzhov wrote:
>>
>>
>> On 1/14/24 19:16, Benjamin ROBIN wrote:
>>> Use const_iterator instead. Fix container-anti-pattern Clazy warning
>>>
>>> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
>>> ---
>>>    src/KsAdvFilteringDialog.cpp | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
>>> index 4683c3d..247f912 100644
>>> --- a/src/KsAdvFilteringDialog.cpp
>>> +++ b/src/KsAdvFilteringDialog.cpp
>>> @@ -276,8 +276,8 @@ void KsAdvFilteringDialog::_makeFilterTable()
>>>    	headers << "Delete" << "Stream" << "Event" << " Id" << "Filter";
>>>    	_table->init(headers, _filters.count());
>>> -	for(auto f : _filters.keys()) {
>>> -		QStringList thisFilter = _filters.value(f).split(":");
>>> +	for (auto it = _filters.cbegin(), end = _filters.cend(); it != end; ++it) {
>>
>> Do we need to use iterator here?
>> Perhaps you can do something like:
>>
>> for (const auto &[key, val] : _filters) {
> 
> Unfortunately, you cannot do that, as far as I know (this not compile).
> C++ range-based for loop is using iterator behind the scene. See [1].
> And there is still the problem of range-loop-detach (see patch 0005).
> Using const iterator is the most explicit and safe way to iterate over a
> container in Qt, so why not using it?

I see your point. I am applying this patch together with all v2 patches 
you sent.

Are you considering sending new version of the "[31/34] Fix comparison 
of integers of different signs warnings"?

Thanks,
Y.

> 
> [1] https://en.cppreference.com/w/cpp/language/range-for
>   
>> Thanks!
>> Y.
>>
>>> +		QStringList thisFilter = it.value().split(":");
>>>    		i1 = new QTableWidgetItem(thisFilter[0]);
>>>    		_table->setItem(count, 1, i1);
>>> @@ -285,7 +285,7 @@ void KsAdvFilteringDialog::_makeFilterTable()
>>>    		i1 = new QTableWidgetItem(thisFilter[1]);
>>>    		_table->setItem(count, 2, i1);
>>> -		i2 = new QTableWidgetItem(tr("%1").arg(f));
>>> +		i2 = new QTableWidgetItem(tr("%1").arg(it.key()));
>>>    		_table->setItem(count, 3, i2);
>>>    		i3 = new QTableWidgetItem(thisFilter[2]);
