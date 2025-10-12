Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E9F1A2630
	for <linux-trace-devel@vger.kernel.org>; Sun, 12 Oct 2025 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760298136; cv=none; b=Hb0ZEl1A3ERXPl6gTf2ybmiKwf5stNERE6qhWVegtzgM71VT/z2JXKlkdLpf99fC7ffp6xJoIwiFzoTmvTBkZSIeWITe2++aSMKwZs5w3MixuQgSUnrPBFZCiJNBa4Mt0MvJc48W//OyyVP1UiF6yLakvoAZJUUsgufH48ZDXig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760298136; c=relaxed/simple;
	bh=0oJNcLT2ZfcCDq0WPLkZWPylsOXJb2Y+Y+dBaBEin+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iQ9KMVgS69WRgwPOwx9SlpIC8loOdhFs8L3l6VB3m8J6WXhqFUoykYeBI0TxN6W+Yj/LW4GY5OJKBjheBBdj3jlw4KLopO0q00GeKccvXvyAJSQiybjNV676XkoubL4C6KsllUJtEI9vk/EibSQix/NIcciagssANOSCS1gFRoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TI5751Ym; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TI5751Ym"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e3cdc1a6aso25575515e9.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Oct 2025 12:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760298130; x=1760902930; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h82/TWQT/7yNtX30+O59myTkaXYnJrycXBAeTHpYTUE=;
        b=TI5751YmYbe1z1qSrPc9QW4J94ehp+Ep+Lw9QQQDLi2Ef2o5Fq4domo2iKBdvJR+4v
         ebpJPfcieALfZPeWaoIPrj3n0u2VoOrX5hFwFjitWeg0mfrxymUFdoaaEPKi7oKEADo5
         CB0TS6v73TMJaClB+Q4TX2YHWw+t8pkyJiPhMhGmC8VNW4WWjB4xMS+Y/t9kQFAcXXL2
         3tuCrJk+XZAeWiWC3NC1x6NpxdYX7Pi6m+gl439IWf/o2p4PbU59R2/RaaVPY0g4ReRC
         hs/I9I54YdaZGvMXzUDMb/zsbV0VJiiAc4Dw3ZOcFjvVpSPZ9Gp/PpQ2CaZFC1w3X3fY
         rbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760298130; x=1760902930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h82/TWQT/7yNtX30+O59myTkaXYnJrycXBAeTHpYTUE=;
        b=rnUY9FICBibbam3I3B3ETeIEGo24uQ+OsTFJAfAhPlza5nBEy0FcBtXzKOcmd33vM/
         MjEIFXwFWm3DA8CH+aeyrwFy4DAqDt86pUJQUzOuFtuCgOwlRiBwzDGlhZmrhOA8Bvl/
         VIqflBtzjzJTU+ReUOlahvzYPp9mECIo/Jnvtpnqzc2wz0MRJ4Inf5GejbOlXoMxfr5l
         eqon95yOsVS9RtTnVLxKe2NrTvr4l4zLk6xJcpNntAVr2xCypSOqMRhMrQkN1D1xlsAQ
         vqRGwW2hUZ25ISsgotq5GNu94VDQzmaHy+5MPlvJbp2TYTr13l3b2YFfQBnTOdZ66ErO
         fTDw==
X-Forwarded-Encrypted: i=1; AJvYcCVU5BN5yYeSOZnxxgToNsReC+O0Jaed/naKTkrioFgdfDybBBSEHR1TjI1p6Efy3sKkXoaiu/Sv+/uzpo54st8qGA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4AVKZxHSXQq+KZO335iLr0hVwjYKk03HN296vCprSjDhW8I/4
	RKCWwfyF2MhLVbAZZKaY3kplAkfLuc8OO0txz58Q/0z+nsODdoHnjpMdJavUKg==
X-Gm-Gg: ASbGnctX8G80pwdJGtt3Gx09ApErj+XaXd64vMsloSF/awX8VWKMbGxqHKOp+CVlUqa
	7rnbQgoQ/5vvSFu07gxGeDx5A0Ro5QGsXr+HR+AZMoba4h2pTQ0IIBuFSOi9RHSMB3XnFRFtB27
	RSq+BjnXCMTiLAar5Y0lQmErzWYGXQCfakksbIPyotMVuDjxBq19ifLr3ssf4qIjQNFgueX07e/
	nuJId7OOJ6Yiel6DGkBsYZhfHM8zKw94aG9nwXjbknSLrQQHr8nDfnq45qPGqphXQ5eWl21kCMH
	ocZXKEgzIDIIJKTe4qCXso5QJQLQFtM145xoIWH6AUDY85J8Ztw10qnOdkDKl61EGvuBa+93L9q
	PPmdsYhHYPKDbbG9B6R6amMBrRAzRnOLu+GH0Xg90RUvKUWd6aJ+8B06TRnrrhvm4SA==
X-Google-Smtp-Source: AGHT+IFJLstFDhVZZ4XP25iaaBGXlFxVHnTnNSIyIDosJX7xrf7ZgrsJF1o7+Zy2nsu+NFqpk3QuJA==
X-Received: by 2002:a05:600c:4ed4:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-46fa9ec7718mr138397515e9.14.1760298129690;
        Sun, 12 Oct 2025 12:42:09 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3e3520sm116752125e9.2.2025.10.12.12.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Oct 2025 12:42:08 -0700 (PDT)
Message-ID: <8ee075a3-24aa-e8a5-85f2-fcc7ebd46900@gmail.com>
Date: Sun, 12 Oct 2025 22:42:06 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: make sure ksmodels index is valid before use
To: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>,
 linux-trace-devel@vger.kernel.org
References: <2a04a19a-5c3c-4724-862a-26fae85638dd.ref@yahoo.com>
 <2a04a19a-5c3c-4724-862a-26fae85638dd@yahoo.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <2a04a19a-5c3c-4724-862a-26fae85638dd@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mircea,

There are two issues with this patch.

First, please provide more detailed instruction how to reproduce the 
problem, because I tried "Pressing Ctrl+C with no data loaded" and I see 
no crash. Nevertheless, the change you suggest looks like a valid fix to me.

The second issue is that the patch itself fails to apply.
My guess is that your Yahoo mail server is messing the text encoding of 
the patch resulting in git rejecting it.

Cheers,
Yordan


On 10/11/25 14:45, Mircea Cirjaliu wrote:
> Pressing Ctrl+C with no data loaded will lead to a crash.
> 
> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
> ---
>   src/KsModels.cpp | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/KsModels.cpp b/src/KsModels.cpp
> index c8a6ba3..cf4cfe9 100644
> --- a/src/KsModels.cpp
> +++ b/src/KsModels.cpp
> @@ -309,7 +309,8 @@ QVariant KsViewModel::data(const QModelIndex &index, 
> int role) const
>       }
> 
>       if (role == Qt::DisplayRole)
> -        return this->getValue(index.column(), index.row());
> +        if (index.isValid())
> +            return this->getValue(index.column(), index.row());
> 
>       return {};
>   }
