Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB34F2E0910
	for <linux-trace-devel@vger.kernel.org>; Mon, 27 Oct 2025 20:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761595300; cv=none; b=eSWtf9agQCX44YtjVb+tCCCvOuzmmO/HRVGE0/q91SED/CGIhag0+NxMgCCU78T5VEs6SLdjxSWnbJLxjtXBDXzUqeX4RaPA22zoKM0KHjXRgEwEnClAls4cikbAntAXxJbAxU0E2MbH6jTpMnrKyxKdnYuhxycGw8SOXLofGtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761595300; c=relaxed/simple;
	bh=eSJEaee1kGUNkVjuv3gEAanA80M42N4nfZRQk0SIVg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YG39SOOG/SZ8bp7Kpe8r3eLnHD9Lyfr3qdaLSpzLuu9Hoxw2tbuYjVCfkOO2P1pIaxV23mQYYTitn2xMDyTBSuJd08mzckBVgLH8iTYV08Vt4OtFyl6IIcaphAReQVQdqGxmBLV75Ja7eGRz2unqlfnFidkZVUrYGqI3vnU+4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CK10zC2d; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CK10zC2d"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b5e19810703so791822566b.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Oct 2025 13:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761595297; x=1762200097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gKclc5pH7r3Gf2/zi2t4b1FRFWr57tY1woCb1b9RW6U=;
        b=CK10zC2dEYZuSWL9LAscTEcqe65WCVvGK2qx1PpWDpeanTOVWxyVgBx4ouGoM7owlt
         31eCWAgciihbXhBCz5tLjCHn1+J/tFHqZSla9Hzm6E9VS/ZKnSQTeRAn8d19WT+jlK1t
         HxLXJhb3hk3ebcyWIKLXmVIAdW7s2uvcgx8JprvC2rS0WGqCym27Plx40gCmeRqocWx9
         Z6fAMuRu3iTViqRUQdqpVqeYSAVkmkI048/cqhjBLZuol6fYVdZgeg+1dhLtgBKdYgsS
         NiiGIOZGaS1wfE+hXRPTYKrVVy7xgExHRgDAota3a6AVq66DV7ZeiU6pZLU7ea3NJ/Bk
         i/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761595297; x=1762200097;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gKclc5pH7r3Gf2/zi2t4b1FRFWr57tY1woCb1b9RW6U=;
        b=UpYUCYYXfSSnVQ5zUtPxStjgFOvjDBAFc7PRDyPaiP0GNSvud1YqRjRe1pjX8B+KOB
         cZO7q39G5o12yUYyQWkELrNQRS4s0ZoOLdT9VVibgPD46O4QDuQzUE4XgOtpYN6cPg9S
         AWlebpdB7LS6hVBRGW4/tvHaXvWLgzONDfCxU/PVtN4subey/pScU5g6HhmuU7R+ldHa
         inLIbgImoUntSQZv6IvPjRqDDA/jJfbRTKZrgeZdnpXM0Cgyi5U1ee2Zp1a2fRT8VcYB
         MiNuL7pI/a09oG0tR9sWH+la1vrqEuxh5k77eRLEGIv2t5MOLKkOINcP5ysoD+j9nIJg
         RDGg==
X-Forwarded-Encrypted: i=1; AJvYcCUcNvMOZ7PYLO7Rim7/ux33HGJKo4Fh5+bXoSYpkFQ3Xsq3GA8voH4CnXqwGRwIdlH6406zu6ftG/gG3/C8TkxHXA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLAryIcQ9L7UbUiq3Jl59Jv4qhi19aZUm1pGUYQj+12xV62/p2
	OrGK9wtEWpCBIJyPRme6whcVUrh+YNWhPgil3mE4+ZWFnec21Uul0T7hxztNHQ==
X-Gm-Gg: ASbGnctzY/JfPwmBq0owmp0XIA1N8+5Hl9Oq37052pksFS3JQ2l78VxetuZe9kbkTJc
	B0orpTjYJNtq9UQ4FoZqkngOIuoibqPVHkf2/+hxn1NvEL9EuohxfOQZHWdHlOKYAqKTe0OH0ea
	n6mEAeRhtyQEnnR64RHiziVU4t47ZBPaYaYCwaRGrce3B0CpJGM5eIFhR8fbjWWL1O5djXeCh04
	Grq/6f8LOS0jBbPGzr/Qx4Xgt5eLWIYt5WwevXopXL+4CiGcdm15mUgcB2fmo56/uE8inFS8Zgn
	2MH7MQxoRH4U/mOk78fSlr/pqrcx2RLJnEyqL8vgHicae4J2hE+igBKljHoO7HhjnM7EHy9oAVZ
	S2PXJ0+AcrNibMGNmoNzaLu5WHaD/VAQ32pv1CjIoYw5XnGwoMvnDK+45mhgi+uUlFJh+PBSVxk
	n1l40RqhPsWo1yLjyciqlAx2jvcm6WAWdYjRw=
X-Google-Smtp-Source: AGHT+IFtmM5Ss7MlKv4hGCfaF9DRKrCj7Vf3UtXjh8OScquNxEXskYf1jf/QtBzHuunD22dAReM9Kw==
X-Received: by 2002:a17:907:7255:b0:b2d:a873:38d with SMTP id a640c23a62f3a-b6dba58bf7cmr131507766b.43.1761595296987;
        Mon, 27 Oct 2025 13:01:36 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8540807bsm844858766b.54.2025.10.27.13.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 13:01:36 -0700 (PDT)
Message-ID: <67b3a43c-8d6d-b1e0-de72-d7d7127bdbd2@gmail.com>
Date: Mon, 27 Oct 2025 22:01:35 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: add .gitignore for generated/build files
Content-Language: en-US
To: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>,
 linux-trace-devel@vger.kernel.org
References: <ed24336c-4e14-48f5-ab0d-cd5f6f3f5c01.ref@yahoo.com>
 <ed24336c-4e14-48f5-ab0d-cd5f6f3f5c01@yahoo.com>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <ed24336c-4e14-48f5-ab0d-cd5f6f3f5c01@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mircea,

On 10/24/25 23:01, Mircea Cirjaliu wrote:
> Not having a .gitignore will bloat git listings.
> Created a .gitignore for all build artifacts.
> 
> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
> ---
>   .gitignore | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>   create mode 100644 .gitignore
> 
> diff --git a/.gitignore b/.gitignore
> new file mode 100644
> index 0000000..38a45ac
> --- /dev/null
> +++ b/.gitignore
> @@ -0,0 +1,16 @@
> +.vscode/
> +build/.cmake/
> +build/.qt/
> +build/CMakeCache.txt

There are files that are missing from the list here.
I guess this is because you are missing some of the
optional dependencies.
Please add also:

build/CMakeDoxyfile.in
build/CMakeDoxygenDefaults.cmake
build/CTestTestfile.cmake
build/tests/

> +build/CMakeFiles/
> +build/Makefile
> +build/cmake_install.cmake
> +build/compile_commands.json
> +build/examples/
> +build/include/
> +build/src/
> +bin/
> +lib/

and this directory:

tests/

> +kernelshark.desktop
> +libkshark.pc
> +org.freedesktop.kshark-record.policy

Thanks,
Yordan
