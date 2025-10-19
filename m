Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3B9354AC9
	for <linux-trace-devel@vger.kernel.org>; Sun, 19 Oct 2025 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760885308; cv=none; b=dtC+Tle/dhgkh3A0slM3EZaUpuq0q7KU7u0wuF87DEwHXnSkzIE9LQdPFValzZEvHkbcN4LjWgahU+YlQkeqIc5OTWyIdrj8m4jEz2FchFcOzdtlga/uHlAOzf4pF0cqmz4jwuyqkbFWj0vylpAT4gbQ1I6Xu9F0Vl4AnE2vCyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760885308; c=relaxed/simple;
	bh=U8UjyxEa3/KNgtvZC1MHvngatZZBLF3KW9geZCETQYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XUb4B08v9fS5aTJME/LWab698h/5nwvz3WOCz/rZZulUdeVAVLpKGCETq1/MdIt/3WCGCuxUKd7RCMJTRcrlCW9hC4bKbxwBT/qQNbmF448vw9sWdwhe7mxk8UfKEYm0QswkKF+c5UkBT9Tdcm2OkdnYhfaNArJqdyWXqebVw+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VKGD5WnH; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKGD5WnH"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ece1102998so3081260f8f.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 19 Oct 2025 07:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760885305; x=1761490105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hU7NKC80OxUa8xiLeEv9KhMHbsSbRM000bArJ2AG654=;
        b=VKGD5WnHE+Exgr/0mfZakgw7gTEuYHfmPKig2TjrTNVWtqSajUsRSKQ0Mxi5Hvs0/f
         J7zWYh5lPH0t1cxXqqNeIqyy04Y1QfAYvrsVv71iqDVkd5SvpNWwQb4xNIJL9/Bc0+Po
         m71rgdfHTIL8OtTGM33luyzr15IRaT9Crp+ocTOOcgCXIXwabo6CJWxEzbiJp46APho4
         1lcMWCyPwVMaABeIrT0aVuEthpJ7DMB85R/sf7UXdGr8++jEf5XOSijpNW1FHeUpQATv
         uKfOYiKCLAhN1D4Afmysydsury8mhTI5QfBf64NP1pmObts34qsmkHw7Emd2FUoPtcTh
         PCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760885305; x=1761490105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hU7NKC80OxUa8xiLeEv9KhMHbsSbRM000bArJ2AG654=;
        b=NLKuufxjIxv1tcukZJxnXaV/fNVcSoxCPt3WY3XLK38lgYs9KPCzt43J/8Ol4drPIa
         +8A6gKeF5s7DTaZ/Yn7o8GdjIiEaQmA5TwpMUI9+GBWtrvPX1nAN1hJ0LTTRWagtVgta
         HADzTpSKpCDwLso3DbJ3NobkejnU4JqkovZkRKW34NXZbTk9vAszgQFaESJ0bsXx2mL+
         aMLd2YAu3WKgzY5+0R2BCOhU9x/hWYb6tQAzf6TFK7noODQ8J+JfUSiZdHeb5Zp+Tc8y
         NBbB94ea/v9lEXXSxMXw7BqKSHUWDUCpmkqOuiUj8WOgGLIYs8DYqOhfc0aGK3daAsaP
         xEaw==
X-Forwarded-Encrypted: i=1; AJvYcCUID5GJCpSbqswGVqYENoWeTiUcvD+v0E0KFo9DbyA1UipyqT/WHQmLSEZpISTqnPnB/IWdwmeGg7TAAFWvi7Og8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWObXcFWxaxyhQfnb7njgzkERZGF6yFPsZajnUpW9gHT3l0dNQ
	rO2tO/fGjvRqyDzA66dpNQB5qyNk2+wTn56O0eWzQEH0gDEhtkP27CdF
X-Gm-Gg: ASbGncubcRZnsHA7cMt5u7NeAx2DmAfuOPtTry8xGLB/LssujSI4Ti63hyyKnITPtuA
	NpWjYY2uMmHaObMpB6nwHvDycsSNsNMr0Bq5yJZMhPkbBTHn9e3ti7o7aJZ5jPr9S7suiE+uYvN
	vNviX4DgKZqlYODdVQlO3+El67w+XXUoPhrqin9r8TKEEHKs3covp6HitmfAwO0qdBetR50rWNj
	Vj+By3Q3P4g5o5qxExykuPDtFKnh2EBy9lhSo9onVKfH1qci3LDfaECnBYUCZnTWZBJK1ImLG4j
	I+NORmX9Ed+JmbxL/6/3k6SE+cUCW8xw/aPT2mFFOXiWBBWA8GFcLRlg/9APBZnCCO329D1ZVOe
	WO4aRXviu2jcq3Z0CMekSfBG90C7TWO/LJoX7k+2TshUbZUfRGJRjvILlhDGkagZxbrhprnFEwk
	f/vTX1ecLu+YQ0UmLZSwH57evu
X-Google-Smtp-Source: AGHT+IGniNvXdKn99RLr1kfg2p+1surpinIAq2yyhvj+gFIKlyXfUROKnYzNOgCDalPDftbOz/jo1g==
X-Received: by 2002:a05:600c:8b66:b0:46e:1d8d:cfa2 with SMTP id 5b1f17b1804b1-471179117b3mr66839485e9.20.1760885304582;
        Sun, 19 Oct 2025 07:48:24 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cd833ebsm92430535e9.3.2025.10.19.07.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 07:48:23 -0700 (PDT)
Message-ID: <29dc77fc-d7e1-661f-dda2-f3d4ecd11f3a@gmail.com>
Date: Sun, 19 Oct 2025 17:48:22 +0300
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
References: <51e122b0-8154-4e41-99ba-996ff42e5e98.ref@yahoo.com>
 <51e122b0-8154-4e41-99ba-996ff42e5e98@yahoo.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <51e122b0-8154-4e41-99ba-996ff42e5e98@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan

On 10/13/25 23:07, Mircea Cirjaliu wrote:
> 
> Pressing Ctrl+C with no data loaded will lead to a crash.
> Steps to reproduce:
> Click in the trace viewer window.
> Press Ctrl+C.
> 
> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
> ---
>   src/KsModels.cpp | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/KsModels.cpp b/src/KsModels.cpp
> index c8a6ba3..cf4cfe9 100644
> --- a/src/KsModels.cpp
> +++ b/src/KsModels.cpp
> @@ -309,7 +309,8 @@ QVariant KsViewModel::data(const QModelIndex &index, int role) const
>   	}
>   
>   	if (role == Qt::DisplayRole)
> -		return this->getValue(index.column(), index.row());
> +		if (index.isValid())
> +			return this->getValue(index.column(), index.row());
>   
>   	return {};
>   }
