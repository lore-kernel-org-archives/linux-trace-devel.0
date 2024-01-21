Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333A9381AB
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705857366; cv=none; b=okXi91jFckChzmW3PWGYGG5GKgDSdtITOsVWBTEy5MqOonxDJXpzHdKJ9xShBatfpB2o5oApOmPvI3AL60HXf8apjwH2VhKF9foaKuB9KSayd8WGqgy71k1Rop+WLS1umqyYpzeSz99GWSHuagOUJSOECsTemczmVMRsH77cCuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705857366; c=relaxed/simple;
	bh=JvXeoLZC159VEnqnsJrfq3DeG+XjUzNCemVUy5mV2PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KDQK7XOznbwqeHwMmEs+Qn0yudyxFLPjPS3jEojvx1EUta/1+0lVvqiE3DZVYIAr78C8AlygeN/AfoxS+PinZnNgRPyUk/xgJ5yug4zlunpIwKKssCR0hil5gPgd/ZrFAMH+raCpNp02cQ84z/TB5hT9sooDNZwZwpK62Av7QEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=neTFW3+E; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="neTFW3+E"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-554fe147ddeso3355738a12.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 09:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705857363; x=1706462163; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EFGCC0gacu0AB+kPUD6Huw2QBHhCN+tOM/tlAP87sWU=;
        b=neTFW3+E8EUoGfGvX8rfvyj6e6yRKcHtSctTQRm/xi5Fb/ieB5EIQ+XnShyBI3jwcg
         8NujKe1jJUbO0dA+hs/pXckQ6XQsMaK8/gWxI3g3+n9eDTJOYQ3ptsQfYgclaxPTAsMl
         9c8UOnk9inEzW3CiPZGbR8JlP+WEO7xxosXgwGp9DW6xt2ciOW+m/NNM/X58gLpCJvWE
         wECpnYAHUcbVa19WEL0XjQil2XmalTRroBahgayVUoDA/5NBfSkyYndjr1zVnw5P7tKS
         qkL9pT3gEneQBI/a228R+SgLFCfdiAULFCwfHkAV5U2VezdcAx0l5wrh5ZiebkfUOHkc
         2NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705857363; x=1706462163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFGCC0gacu0AB+kPUD6Huw2QBHhCN+tOM/tlAP87sWU=;
        b=Toahb0dsot+3jXrLGbmKgsRux1wu0tj7DJQvONpcniHmVA3A2JZO8jOOrVA8gDfwo+
         ALj6ogzruXtQT4hWLG0aFni3XTQ2Yu4HyuKHBpPVVkHINarF5kN0YOtvNtRWJ3bVBSJ/
         ti4sTuulrWP9riZwEpMXR6t/avo0kf0t21eHVzvNGF51rwtSHkptX0ZNU9U5inD8OsMv
         03s9NP+WeMWOtwNzPM8r7tKIeToxw17EvbttSl8r5qBjg4TXywHex6H3ScM51wuABj6D
         UJoz+nNskTlXukSWawASsvByvCCLIUyyPcdiVpFS/F7uUG40GcFmBzAuIVj+s3pVvO57
         o+YA==
X-Gm-Message-State: AOJu0YyeZDKdouNJk91BqENNrQOuN/AKGMkIKDvuPsFEdSbUTqR6nHXf
	3Cy3tAnvk64g/WHagQAwvqJbPItWDlUo7ihpva4fRPd5nAUb8gqvNZci0yhv
X-Google-Smtp-Source: AGHT+IGN1/C0YCkR0G5dh8otI70RO1qyuFCBJBFgmWYB3ovudhJ23HkYnYGJX4ARqCG6TVCBOH/ePA==
X-Received: by 2002:a17:906:2b15:b0:a26:9d1c:a73f with SMTP id a21-20020a1709062b1500b00a269d1ca73fmr958177ejg.297.1705857362878;
        Sun, 21 Jan 2024 09:16:02 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id lz3-20020a170906fb0300b00a26a061eef8sm12534860ejb.69.2024.01.21.09.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 09:16:02 -0800 (PST)
Message-ID: <56c65e9b-7536-3246-5250-7a68e36daa36@gmail.com>
Date: Sun, 21 Jan 2024 19:16:01 +0200
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
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-5-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-5-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:16, Benjamin ROBIN wrote:
> Use const_iterator instead. Fix container-anti-pattern Clazy warning
> 
> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> ---
>   src/KsAdvFilteringDialog.cpp | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
> index 4683c3d..247f912 100644
> --- a/src/KsAdvFilteringDialog.cpp
> +++ b/src/KsAdvFilteringDialog.cpp
> @@ -276,8 +276,8 @@ void KsAdvFilteringDialog::_makeFilterTable()
>   	headers << "Delete" << "Stream" << "Event" << " Id" << "Filter";
>   	_table->init(headers, _filters.count());
>   
> -	for(auto f : _filters.keys()) {
> -		QStringList thisFilter = _filters.value(f).split(":");
> +	for (auto it = _filters.cbegin(), end = _filters.cend(); it != end; ++it) {

Do we need to use iterator here?
Perhaps you can do something like:

for (const auto &[key, val] : _filters) {

Thanks!
Y.

> +		QStringList thisFilter = it.value().split(":");
>   
>   		i1 = new QTableWidgetItem(thisFilter[0]);
>   		_table->setItem(count, 1, i1);
> @@ -285,7 +285,7 @@ void KsAdvFilteringDialog::_makeFilterTable()
>   		i1 = new QTableWidgetItem(thisFilter[1]);
>   		_table->setItem(count, 2, i1);
>   
> -		i2 = new QTableWidgetItem(tr("%1").arg(f));
> +		i2 = new QTableWidgetItem(tr("%1").arg(it.key()));
>   		_table->setItem(count, 3, i2);
>   
>   		i3 = new QTableWidgetItem(thisFilter[2]);
