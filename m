Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F89F13AC0
	for <linux-trace-devel@vger.kernel.org>; Fri,  1 Mar 2024 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315324; cv=none; b=Va1YVLb7LgaLJYc/MNp0kiwsnP/fetYgFP3OaHaEWuo5laEoz2J21QLZpsq2PJln6xtT6D8lfZ8UH8d0vq0GHCMK2fwSwL4MhJcVUB8zzY/7kBiaJ+XVInXEDldYgt0g5McKOYfwjn61Cvu2OyCngSa2c2xkPyAUWTFoJaurRjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315324; c=relaxed/simple;
	bh=hUUqnks2p+/3X385HFETkYBrXPIhfwhBZfYEO3Iu52g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUvnsBTDMJ4vG4ykZHRa/lZM7JGxB/fL8N+xkGD6NFfBtNYVWUuA5QMUt+tpblV6D+3eXnU6CFA35ZqCutU7GW2Mn55+dJVfeenyMMyd2wHSb2WxCmbThj5MLHtyzCOc2TzDRJiYX+6ss+XVynLv0IAQGQzv3h7p19PfGBdUKrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fZpF+7Sf; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZpF+7Sf"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d109e82bd0so26222371fa.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Mar 2024 09:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709315320; x=1709920120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e1T8lZXg+cNg7cWnbUKwv3hj767O+zQKbyg0qHKFzOA=;
        b=fZpF+7Sff2sP3y1nDR1kNqSr/6s+JLWJpmJmIyKGAbZDHlsocEZXcE5/7OY4yHE1lC
         Z+SM0zXP5+fmrRLZsxZ3d7UA9JwzhaPHKkfsrxwdsTNqPD8q8wixf8RcQ+8EpLvRpySd
         TF4xB24ZndWIgkk0INE5Zfin/gjVsaUbA+rTq3MDFXAnwUWGV3s6l01ZtOY4ZX/AzIxr
         2mWRfXrO9oxTtiWmWI9FQ7+FKmKX5XE72AYIA+Lzn9Cp2J81EDSSc+cONw1FaxsiTSw+
         zZGFn+7BxRrOgK7S4PTxGn/lH/3nfv7Cexm9x/SmLeLqXE9COaxAi5Xw4FFk0puliJh3
         cX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709315320; x=1709920120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e1T8lZXg+cNg7cWnbUKwv3hj767O+zQKbyg0qHKFzOA=;
        b=Ek93rH2QQfjfrkY2t9K4g+RkYJ+wbUaimOHDSjvrOdpGhs8JqT1V8RsaCj/sSVAQAp
         nYTiXKU1cC/4C0cN9fjWotXiZvhhbKzt2q7wfBQssilCJntozIDwLyv2/Uve3gYEAXh9
         wJbntrCmYgbosp4PkL4z8k2AFhDf32ORFV25aSvGkc7kFOtAVoByP58f0aC8Bwv4nGbP
         WxM1mkiwx78b4peMNJanaPcWoiH9ayP0MRcl7onHv5aoI/47nEY11Ez0m2PdsjcIGeIp
         3lEkzAMI6tGVtQS7ZJPzw2Z8ohdan0LXwg81oWOqtCWT8Uq+ZwkuotTukXi6FKpeq6ko
         ur+A==
X-Forwarded-Encrypted: i=1; AJvYcCURmmUUQTRAIzLBr0b1vxYak9nbPEThsOO10ZAhoagyGneDx3VhefwswQx8v7rc7YLQHlx2QREi7dA8SNKEe2lbdCPC3kNjZjdr58vjG3ITazA=
X-Gm-Message-State: AOJu0YzoMOTEv87w5whj8VqyZUJbuHm74l876sFuUfOhPEXNLd4TWYyb
	d/S1H3azfX8hGEGuh6XTaVtL0dBB9Z1rGXyF1diGz9e7PBt3bXtQ
X-Google-Smtp-Source: AGHT+IERhvRl0UblJFF+asPmRJkeWOaTeZVkHAWclS8d95xGm3/oZQIaTLkA7hWP3ZMrjilLBzFxng==
X-Received: by 2002:a2e:2282:0:b0:2d3:2642:ec29 with SMTP id i124-20020a2e2282000000b002d32642ec29mr1867829lji.8.1709315320190;
        Fri, 01 Mar 2024 09:48:40 -0800 (PST)
Received: from [192.168.1.101] (95-43-240-214.ip.btc-net.bg. [95.43.240.214])
        by smtp.gmail.com with ESMTPSA id l27-20020a05600c1d1b00b00412c7b91ef0sm2733793wms.37.2024.03.01.09.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 09:48:39 -0800 (PST)
Message-ID: <37376735-eee3-135f-616b-d6fa88ec77cd@gmail.com>
Date: Fri, 1 Mar 2024 19:48:38 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: kernel-shark fails to display
Content-Language: en-US
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <CADVatmNXhhn6xhL-=rYqDaHqp4Ct+_i5N42KpeJnnxwoH1Ee+A@mail.gmail.com>
 <04601fe7-f487-c50c-1b8f-38662e92813f@gmail.com>
 <CADVatmPECgAXGF164YmbqExBA1PCKYJ8ia-UhxWYs+yUpKo7Mg@mail.gmail.com>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <CADVatmPECgAXGF164YmbqExBA1PCKYJ8ia-UhxWYs+yUpKo7Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sudip,

On 2/29/24 21:55, Sudip Mukherjee wrote:
> The trace.dat is working, I have been able to open the same trace.dat
> file with the previous version of kernelshark.
> Next, I tried to open an old trace.dat (created with old kernelshark)
> with the latest version  and that also failed.
> I can send you the trace.dat and also a .deb package for Debian which
> you can install and test, but it will take a few days. I can only do
> it after the t64 transition is over.

Please send the .dat file and the package. Indeed, so far I tried to 
reproduce the bug on different distros, but only after building 
kernelshark from source. Also please note that I merged some patches 
with fixes after the latest tag.

Thanks,
Y.
