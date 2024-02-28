Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ED91DDF4
	for <linux-trace-devel@vger.kernel.org>; Wed, 28 Feb 2024 20:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709152821; cv=none; b=VmC6nya0LOa4V1myj5QyzloIZ6W9BcM0xNnqfsPimr9DitgdHt8XvVIEOVLT3isuYOypN4NcgNx4XrCMWl6De0D/s61pACClxbgINtUEdK9zWFvKpDZsCOygrGImtMy6y6mpbaJQmnNKrV2/4UcoIC2zU2dgLGU1POqsInNV8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709152821; c=relaxed/simple;
	bh=LS19MRa6BAPhqtGtA9DgsO1jj3ESRBiERXnjAHdXjRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SGuktco2b8u/C4Ef16BWHJ1Vv3Lno+57GQrqv1MCW5DAI07gljCzPKeTcLiieSKueelwxeRDjp2pqqhebTlHb4Z+NQYwr1Fz3kFHKcQD360Y4+GSg4jv6zsLVztY0UNm5CcvfzVtt/eVcYanrbnjPaQA6PMwMcuyBFbG1hkQjY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTxKtNDo; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTxKtNDo"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5101cd91017so96914e87.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Feb 2024 12:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709152818; x=1709757618; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dND8t+zFWrPTPnhEgRqMoakWZzLG8t/SoyMVi9W4FRI=;
        b=JTxKtNDo9WJjFxKh5VLzmqmOvHFW4uS1DqVOmrfNHPhfXbKa+KhJfqmFgvSbUbHzO7
         HW2uty2AvSi7P/4B8jzdxczz+zkkuQHsuNyDnO3dRc7DFuakvFYv22iKCuz0bRPPpOeP
         Usfnc/Ac6BpG8fYxHQWQygGpdZTLDmnJpBgxhkChYT0LqMYUpWzCT4tHop0Csa6IiqOt
         sdecUvioXjtl23PEIGJ7wYafO8kRn+OK8cKyeBwr6orvzF4Ey0xHbzgvWxuOy3KKDfDg
         H966oJHfAX81Z/DbodNAujVY0Rrt8TSS2t/a06dFh6wk98/d6FjZFhc39BOFxS8aZflP
         5czQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709152818; x=1709757618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dND8t+zFWrPTPnhEgRqMoakWZzLG8t/SoyMVi9W4FRI=;
        b=O9WgPkQAocpmdILL3mvMCVmLdhmoCsFZxBiix/jJQyPyU0c5IfcImAUozEWuzs/Kzf
         0WelTah53SvhzW8pemPApkStPulaqht4a3HZVY9i5Rz4BlAjYuJ07uREV9iPr2Yf5Jer
         TMIMz+jtB4rMsIDhzbSgJkaeMmvT8dfbSxTSKEpDe5bhk5pzVJoKdelycam0P/+WSM5B
         dC8dGmb7g/5sy76UDAGXQLYm5syUeFUOWMLmVfkaIiTFn9sN5NacndoQH4lTH26sT8yS
         IwMIDIIXWQngBvy0Bgi5tPc/MCnQpeJ+1WgKYGQ7+rW42NLJZ/qZVIpUqflk+w0mRNnf
         v1Iw==
X-Gm-Message-State: AOJu0Yzu8rtxnjLRUgIaTNOqRcqluWmMICx2XO0i6urEG2nKG0tP0hJH
	Z8xA7bk7KQwO8Luf34A3BWscWa8Gqrrm21FYGnRpDqKL8Of5l/MTv7s8CQhc
X-Google-Smtp-Source: AGHT+IETCnfnELdy3v+szolxPaaVIoe2nXyjQDjUI0CqFL020Q/0YrHunaVX86qLuVJFoYEsCJNNuA==
X-Received: by 2002:ac2:545a:0:b0:513:1c06:90e1 with SMTP id d26-20020ac2545a000000b005131c0690e1mr67801lfn.8.1709152817383;
        Wed, 28 Feb 2024 12:40:17 -0800 (PST)
Received: from [192.168.1.101] (95-43-240-214.ip.btc-net.bg. [95.43.240.214])
        by smtp.gmail.com with ESMTPSA id bj20-20020a0560001e1400b0033db0c866f7sm15802157wrb.11.2024.02.28.12.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 12:40:16 -0800 (PST)
Message-ID: <04601fe7-f487-c50c-1b8f-38662e92813f@gmail.com>
Date: Wed, 28 Feb 2024 22:40:15 +0200
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

First of all, I am sorry for the very log time it took me to react to 
the problem you found.

I tried reproducing it on few different machines, but I am not able to 
see it. It would be great if you can help me a bit more, so that I can 
figure out what went wrong in your case.

It seems that the recording itself was successful, but later KernelShark 
fails to open the recorded file. Note that the file (trace.dat) must 
remain in the directory where you started KernelShark even after the 
abortion. Please try to open again this file in KS and check if this 
gives you the same error. If this is the case, send me the trace.dat 
file, so that I can investigate further.

Thanks!
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
