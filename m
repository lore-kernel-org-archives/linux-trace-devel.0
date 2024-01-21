Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BBC381D3
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705863033; cv=none; b=s9GiD8HqwH6Nvk/DE1544hzn0I01keql5mZtKK1AaBdaGc+H2d0fki8R7jUpx9RTC/6+dyVcCeWTtulRGvGtGXu6hs73xSqI4kmdxrzVA4nbEXothDkWIvXLJDt15tEPaepOwoyQJlj0lTB1fwHwcOMXCvWqY/g49hkA9u3vcJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705863033; c=relaxed/simple;
	bh=kiLkZKKT9YWjwmPk2IuVEAPGWRFfTbvnUxrxqHy+Ly4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nu9pzpDiOmRpjhLcXDifmEzrPLW5MH1Vz5hk7VM/C2PNtfXuntXYmrwLdQAM0TiFtPPmfl3sWj4WMnD0bzAKvwl/ZRkwCDnIoFLimdOJhGLVnrcfer1CAJYrNY1ABzCJjVVqrst9tv0I0bjEwz9OZkYEEqBX+Bf6hui/BSk53ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dunvZnvZ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dunvZnvZ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-55a349cf29cso2733034a12.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 10:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705863029; x=1706467829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2oK5S+861L0KolsknwGIY82VDC99K7SjbEHuIRVPSjo=;
        b=dunvZnvZO99Qg4Ie1bO3CtmfCts/uxfyhCiZpsB7SM7aGpWx0fImcmfe3f0cKZcpPp
         uGyYgwfvlMEAZXu/JGOnvTdINvlW5QPMPU2CJQ0ZYa0Lz43I95LdoH4EESXAP6oShpPV
         We9iHPD6aifAiRkD/DHMUqMaXjdXN5ftnQvmALCcCMOVgb8cORs9379YiHhg2M36w7p5
         qkRaxLqH4lgeArM9jlyEz/OB67DMmF0b0gjX2hVPhZnwbtp2i2avkgfo7BaQO344TaIh
         aFy80hxVeWj6o2veibXRQuSyl4bL/E6Qgt4mUoFn82MEehyHZk3Y6sR5G4GNfshFIBAi
         /Uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705863029; x=1706467829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2oK5S+861L0KolsknwGIY82VDC99K7SjbEHuIRVPSjo=;
        b=BM+E5aFSyDskqGQaj6Y4LnKF/kTVKThayIGEgiixLYFk8JBFCqzSPzP8oSIVhe/7Ph
         Mg1wFGm7FM+pxdZVGhVexxDN7W0j6nDm3NFKVAJMyl29MwWLriL+16PdGsAcAiye7cCo
         BGri1v6F8ApU//nzttrFZlnzEGEYvYekbPNpEtNgBLmi8Cbcr+E+qOKadj27dIIgNMlu
         qPHCGR+Z5e83+Jsenp2QIOeSg7mrwbqVqKyGW747yD4ROpKZtu7Rm11qmTp1TF9WHkQ/
         0vgz4DquJXqARTSktaFbNl8zVCQhcpSB7Ybo464qXGt4Kvta0tnLdFOADf18QiVhY8Fw
         J+Og==
X-Gm-Message-State: AOJu0YzsvkeWK+tMC1ab8FH/2RBOinWZ5LzIDt/SLzq1gPd+ka29XQb8
	qZICm+NaniC1HyMt+ynxMnRbSW8NX+c1ioMpm6ueHwlDQUJ9c2SN
X-Google-Smtp-Source: AGHT+IFHsCcJU42MxpEmCF5oeD7bkNKItfmSXCOCUqJxRYQr7CEyQNSU0LMCKz+5K3tv3ZlHMcNhhA==
X-Received: by 2002:a05:6402:3595:b0:55a:8a40:5807 with SMTP id y21-20020a056402359500b0055a8a405807mr2008863edc.38.1705863028943;
        Sun, 21 Jan 2024 10:50:28 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id dm24-20020a05640222d800b0055c1433be60sm1187713edb.50.2024.01.21.10.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 10:50:28 -0800 (PST)
Message-ID: <a6f9937c-7f4a-558b-4f73-993ded8efe4e@gmail.com>
Date: Sun, 21 Jan 2024 20:50:27 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 24/34] kernelshark: Fix potential memory leaks in
 libkshark-tepdata
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-25-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-25-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:17, Benjamin ROBIN wrote:
> - In tepdata_get_field_names(), buffer was never free on error
> - In kshark_tep_open_buffer(), names were never free if
>    kshark_get_data_stream() failed
> - In kshark_tep_open_buffer(), prevent any double free error with
>    "name" and "file" fields of buffer_stream
> - In kshark_tep_init_all_buffers(), return failure code if failed to
>    copy "name" and "file" fields of buffer_stream
> 
> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> ---
>   src/libkshark-tepdata.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 2d0fcb0..d15c155 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -949,6 +949,7 @@ static int tepdata_get_field_names(struct kshark_data_stream *stream,
>   	for (i = 0; i < nr_fields; ++i)
>   		free(buffer[i]);
>   
> +	free(buffer);
>   	return -EFAULT;
>   }
>   
> @@ -1424,8 +1425,10 @@ int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
>   
>   	sd_buffer = kshark_add_stream(kshark_ctx);
>   	buffer_stream = kshark_get_data_stream(kshark_ctx, sd_buffer);
> -	if (!buffer_stream)
> -		return -EFAULT;
> +	if (!buffer_stream) {
> +		ret = -EFAULT;
> +		goto fail;
> +	}
>   
>   	for (i = 0; i < n_buffers; ++i) {
>   		if (strcmp(buffer_name, names[i]) == 0) {
> @@ -1438,7 +1441,8 @@ int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
>   			if (!buffer_stream->name || !buffer_stream->file) {
>   				free(buffer_stream->name);
>   				free(buffer_stream->file);
> -
> +				buffer_stream->name = NULL;
> +				buffer_stream->file = NULL;
>   				ret = -ENOMEM;
>   				break;
>   			}
> @@ -1449,6 +1453,7 @@ int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
>   		}
>   	}
>   
> +fail:

This is not a true 'fail' because the code below gets executed even
if everything is fine. Perhaps you can use "free" or "end" or something
similar?

Thanks,
Y.

>   	for (i = 0; i < n_buffers; ++i)
>   		free(names[i]);
>   	free(names);
> @@ -1500,8 +1505,9 @@ int kshark_tep_init_all_buffers(struct kshark_context *kshark_ctx,
>   		if (!buffer_stream->name || !buffer_stream->file) {
>   			free(buffer_stream->name);
>   			free(buffer_stream->file);
> -			ret = -ENOMEM;
> -			break;
> +			buffer_stream->name = NULL;
> +			buffer_stream->file = NULL;
> +			return -ENOMEM;
>   		}
>   
>   		ret = kshark_tep_stream_init(buffer_stream, buffer_input);
