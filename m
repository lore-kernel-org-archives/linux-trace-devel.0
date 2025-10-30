Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EDF36B972
	for <linux-trace-devel@vger.kernel.org>; Thu, 30 Oct 2025 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850325; cv=none; b=LP/nxVKIXjefz5Oh05TW3xfCuvL3Ib4ifVxMnQAj05eS3o1EWHXoy9mzaHjebYCXHovsjuCH1e5K2JltwrDVXkwj+WNGYXX/EXu9z8rJojltzvcCR1/1jJ4RGfp+V79GLPmuv1DSbRPbKY5WIj3qpcxu0EGBEfpN4mveiPvl9Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850325; c=relaxed/simple;
	bh=5dHzHViK7Ba/+pI0kHciIz68YhKbDDeFiriQ5sQdIbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=A/ZHQj4kgUEiR232yG8so50kw1PREtaY3Wu7IurO5EA4HXFmd+6Yib16WXyMDTEH4LTaeJ3jSUwnsu8lQfIcFrri4+HUSTGwSe+niAeC7qLuaRSc+3q4HEpq7gKOeHaayxqFHUoh6iSflOrCuDXpp1hzU3ztbmU2VsjsVP7ePgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I3412UfX; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I3412UfX"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62fc0b7bf62so2215318a12.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Oct 2025 11:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761850322; x=1762455122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3L4OpeI7ZV+zHqS9BbKX2MvQ58tLkih7C7Sa39eWgiw=;
        b=I3412UfX+f1tD6paarq6NdA0IoMfsygF6wji9FwJldMWbwjT+0o8DmN2PWcZPpexPo
         a+mLCmoJ8ppFrbBVbo+ZAJPb7atJKG6mqrgx9/U/BX3S+1PtTVmsdx94999TPsGA8RT1
         K1QIAvKComJvCNVgGkBIzZYnoe/9yQguDZ7hBYPJBReh6SZHHi6df4uxsWpgVWxbqZE2
         yoSi3QoBnTdHDufOGmt6SAzy7cz2/0GdJP/gAoYbr3zH1QxCbW+OYKe3jo5JlgqfBn4N
         cTG/mxXrjXVYBufftYXSbK3VRgfaCN0bwIhiemcV6ItqN/pesm0rN1Fghgw+zAggAI1r
         /o3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761850322; x=1762455122;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3L4OpeI7ZV+zHqS9BbKX2MvQ58tLkih7C7Sa39eWgiw=;
        b=c2HHJqJL32jwPajMg89BX4LO4MEC2AuY4vDWew2GqLpEo9Ef0x2/x+ShlyiIvlUa15
         VPizQIae0SatVypailRPHtgObDrD/gjAeujh+TKvTC3VJboOOsEZMuyETLr5dzy45OQi
         QTeT+xWFQQAK7DUM8jVBsTq3fhpURTlTzg+Kfj1EBQGUv30h2EfTOoz6THe+dJwTE/WR
         +QYuODMaINbDiv5SuaQ0qUb4/97hc8+KULIFDUf9D1JLz2wzXxVxxmfOl5qNoGg0IONM
         pM/fvi4hKyPxmKNbGAeyWwxWT2SPCMNf0Ek5pDfq9X63CwfWXTu4WlSqV/AljGGvUgq/
         mb0A==
X-Forwarded-Encrypted: i=1; AJvYcCVQ1YKUsmHIC0ae7dcBWnA5YMVlMUBOTpn6rLB49zIsFrGhk4u7ObZ4OFyY7eelK84BMu9g/37FNCDYESbXt7loJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUZdBIRCM0lUv9o2FlKBw1KV/txe/JrgArnlNFNmUZ2Qmn68o+
	9kxetMkWBRuGBHjvj3km630udE9XpqsjVPeKQXDdMA1JthL7gyvVEKQbjlqzOQ==
X-Gm-Gg: ASbGncuUE6IyTWB7R1YQH5qZjVPgwc73Xux+qJ3RpsZZkG0WxgJfW4AZt59NhPBov55
	PmdZSuMhzXw8Ue2z5gNVTvEx4i78xA1wCrUfJ4T94U7drR6vNEQeNLFJeoHYLgSMa2hw9VB8ODK
	2KthAjs9U6agmki8HrVfMqFvlQbIf/WvLYffckiz70u+oDNnBU2F9s+T3p62ekcYShawUEN4ODu
	ngk+IVHo9rAmTe2pNSKsaePUMC/cxZG7FjxMZbrysvF97yOAgbRt9Vlc9ySknc4c2e83d63Y23k
	12nSjrWu1myXCBd1b+pLMMoxHTkCSqHhrkXQx+A+E4UdXa0s6sBPmGlfe6PEyRylTFulT6g8oc7
	Gpvplk3HKEk2kfQe2Q8XWcFVA6P641wfuwWpFnwnyP/2ovVoYTwLW4t4jHzqLkBsiX2Tobus3Gd
	W46eWGUI/ET/yFsrLdlcLZ6CwE
X-Google-Smtp-Source: AGHT+IH2O18YJnDmDGyZv5uUU2VIp7tVrzttyI5wLggdyBfjHe+WwPWPhPgf/x513IbpuQgKgwVJNg==
X-Received: by 2002:a05:6402:1d52:b0:63c:82:619a with SMTP id 4fb4d7f45d1cf-6407704f447mr371533a12.11.1761850321873;
        Thu, 30 Oct 2025 11:52:01 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e7efb97cbsm15739206a12.26.2025.10.30.11.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 11:52:00 -0700 (PDT)
Message-ID: <d435f036-a631-2c48-cec0-849d116d1fb6@gmail.com>
Date: Thu, 30 Oct 2025 20:51:59 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] kernelshark: add .gitignore for generated/build files
Content-Language: en-US
To: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>,
 linux-trace-devel@vger.kernel.org
References: <7f44503b-2ae8-4ac1-8635-a5dd4d0b286f.ref@yahoo.com>
 <7f44503b-2ae8-4ac1-8635-a5dd4d0b286f@yahoo.com>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <7f44503b-2ae8-4ac1-8635-a5dd4d0b286f@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan


On 10/28/25 21:08, Mircea Cirjaliu wrote:
> Not having a .gitignore will bloat git listings.
> Created a .gitignore for all build artifacts.
> 
> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
> ---
>   .gitignore | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>   create mode 100644 .gitignore
> 
> diff --git a/.gitignore b/.gitignore
> new file mode 100644
> index 0000000..cbeb499
> --- /dev/null
> +++ b/.gitignore
> @@ -0,0 +1,24 @@
> +.vscode/
> +build/.cmake/
> +build/.qt/
> +build/CMakeCache.txt
> +build/CMakeFiles/
> +build/CMakeDoxyfile.in
> +build/CMakeDoxygenDefaults.cmake
> +build/CTestTestfile.cmake
> +build/Makefile
> +build/cmake_install.cmake
> +build/compile_commands.json
> +build/examples/
> +build/include/
> +build/src/
> +build/Testing/
> +build/tests/
> +bin/
> +lib/
> +tests/kshark-gui-tests
> +tests/kshark-tests
> +tests/*.so
> +kernelshark.desktop
> +libkshark.pc
> +org.freedesktop.kshark-record.policy
