Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF4381B6
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705856435; cv=none; b=KYvZL+8acJeSYv1dyIkIfuB01zSC3vCtrpJ07jzjEq0nR33Lt+Y6QGAafWMp78QRh9igZwHlrNxCkVRgRo0EH76A0DSnjuqQ3uJYwvmD8FvBbZmzfQXOfBoKxYuJhO3zBF21pJyM3YZsvDHjHBOCsOJUiak+pD7s/DxPJNCCSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705856435; c=relaxed/simple;
	bh=4hBdOe2i3qzNFvQ220bmKy4vkvanpSFxltTEeYQiHgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UTjtOZ5rVlKWJrleWQ+/A1uNWZeUUDXe2oAhAWFHjWmv29Vka1TX14e3xf3Cx0kfjTnm5sDfk4QLfXpy1LRTlrn8+7Rp3X+iJXKUxp49oMTOZDV5MpvjWzw3k2afyNxX5n9PBaysT4aXKkXtsVyjJMNEqke27mYwpIEKsQWOw+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qycr/Eio; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qycr/Eio"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40e913e3f03so31176985e9.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 09:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705856432; x=1706461232; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t2MWaP1yx+UOQxI2jJ4AsKiIqTDVPK69e7/KHvN4WZo=;
        b=Qycr/EioWrcQIeDcHi6p+xZul0FvAeAru4yhhUAQLeVX/FN83K5FwlC3OUwFOM781x
         j2pZ7R7NY9/zoYIDroQSb74WQlcekK/bISpHQhfuMY+vCdZIvWmMnVlj8Yn/sZWslmyw
         OqKPLZRohds9jKwhB+tB8Yt+sqy3y4iGulLKglwkKqMw9i9jCUcWeRD6TIJNPfz1WkRt
         ysnHhRB4HNMXhmHtMR1IvmAZoH20M7AfIPkxnrhSpPTgAAxUjuVBKxqDB5D8nveUHc8w
         5fIkoxhqz/Htzo7wierYwbtepTBaPchLl3mZ2JaA2jPKQEMTufVzhAf1AeyuvtOqD93G
         uQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705856432; x=1706461232;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2MWaP1yx+UOQxI2jJ4AsKiIqTDVPK69e7/KHvN4WZo=;
        b=DnV+03gdr4hYk3JQ0hGUbhSkPRxZWWOHNPG0w0ml5hCC+I97JBZsvWTfMOsdBsJmsK
         XeywTDOUQ2QYVcnUgUg+3tCYaVmgSMQdZFRaw30yOT2ogsxomdslVfvHP1ySWZMy0Tu8
         BmINl7ADlAbGlfDEs1PoBbhn0lOMzqrfepbALJsxf008CFRmwmCzQtQm8aE7rAgO3ABu
         rpw9ljHuMu0LUMR/eyv6MQGzOJgiL2txrC9oFE5UeH0N0coRkqAOWgQ6JO5XX7YMoF7x
         s1N+tTi6JOliKbMdiHZb6tx+Whx/Esl1fCol9Ye/yKdUjbKfbsKKNgI9FnrUHybDA+Ld
         +tog==
X-Gm-Message-State: AOJu0YzuDddxvBbP5kc12PZprFgXp2hUYzicRNNQ/x2Oa5VMm93ehlSZ
	eoLDJ/iGY1Y8hDTLThgnOdf5icXhc3OFERdft2hr8iA2ghbZ+BVUFtHwMPVf
X-Google-Smtp-Source: AGHT+IFEPjJcopSeQRh/ElfdaOQNJPPbdAQfX5phqGF0EGV01EfMF4RHujGg+2u5r2kptLzDIpJxYg==
X-Received: by 2002:a7b:c8c7:0:b0:40e:4576:53f7 with SMTP id f7-20020a7bc8c7000000b0040e457653f7mr1714713wml.49.1705856431478;
        Sun, 21 Jan 2024 09:00:31 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id h26-20020aa7c95a000000b005590dc6a4f6sm10779388edt.80.2024.01.21.09.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 09:00:31 -0800 (PST)
Message-ID: <6b8a5901-5067-b548-af8c-d88e8860a188@gmail.com>
Date: Sun, 21 Jan 2024 19:00:29 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: kernel-shark fails to display
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <CADVatmNXhhn6xhL-=rYqDaHqp4Ct+_i5N42KpeJnnxwoH1Ee+A@mail.gmail.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <CADVatmNXhhn6xhL-=rYqDaHqp4Ct+_i5N42KpeJnnxwoH1Ee+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sudip,

Thanks a lot for reporting the issue!
I will have a look.

Best
Yordan

On 1/20/24 22:50, Sudip Mukherjee wrote:
> Hi,
> 
> I am seeing a problem with the latest version v2.3.0
> Steps to reproduce:
> 1. start kernel-shark
> 2. Go to Record in Tools menu
> 3. Select Events: All
> 4. Select "Display output"
> 5. Click on Apply
> 6. Click on Capture
> 
> It fails with:
> kernelshark: ./src/libkshark-model.c:249: ksmodel_set_upper_edge:
> Assertion `row != BSEARCH_ALL_GREATER' failed.
> Aborted
> 
> 
