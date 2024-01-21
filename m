Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FBB38380
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705862499; cv=none; b=V/WuAFD5yQjg4gAtYaohSPp+Gt5B7iL2AF0DMT5ZBliTz6GXrmGlAQY9U01loEgbBrQCKf1K70QjT3zqtd2Mf20er51hi00AFG2luWdX0RjKF3VtzXL08B3y2L0E6PThkSa3w3cNdVujHJ5/CSiptpwuMwNbYlDj1FS2jlcFyBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705862499; c=relaxed/simple;
	bh=WeQhYVUwweES7C/kuOHDBokqR/EBfobHStFLcjjNq+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRibLunBZQsMz54Q3WU6wbmjk7tLNob4SrJ+semtI2m5WkoM/u6//2SRdRYIUZvvbyixnauQwNyxUYzPDfKyaNoiAI0Zt5hUnCmfJw1JT+BAWEoQFsrkUf571hIJ7IMxcYfi/HrbVmFPlGup1S5uM5Yp06TZ9RMRrlPiHAShFdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b9u5fsZa; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b9u5fsZa"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2cd1232a2c7so31759381fa.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 10:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705862495; x=1706467295; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3CFmbHK8GPyA58wi215EupqB3Iah9rbZ7QSPWnZlYw=;
        b=b9u5fsZaNFO96VQ7DV9cCjB4Vp7UD+SkstrXraRolhuBlH8VTw95FRJb/RMG2NDp8c
         sYbSeSGnDUT7oDmJ9IX/Y/bxDcpSdqJh8B4imQJjryi71TctiP3pnKPJCkJI6pQ6Fldg
         ZUxRjmLmCEQ2MmUyWrnowwnJT2nwZ9SDVV4ygAUeNrHaydyNTa6VlBdKa/4RHmdpY27v
         A32su/VS99/DaabOcHnIn702FAYumRvY82ZFu8eLgpx4hsUCJhiCG/ccGKfdB8WfoTlN
         41Es8PLUIYRjOJ3DIJmr9OuvhpQk28qBLA7O5bvHscFWgWr+npz8DMWRHxEa/PPrtV1X
         B3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705862495; x=1706467295;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3CFmbHK8GPyA58wi215EupqB3Iah9rbZ7QSPWnZlYw=;
        b=U20lHgVocnvt1jqsrSDmJSww2oorml4AhEEPIrMkFPJ3dMOeH9GSqu52b/h+DmUbPt
         BeOZJCkqLMKjB+3SOIdrh7o3fjhGjlMzcbyWcFRZ+enBtePFE+1oGOTh1CRPPEylklK8
         VrU9ShtKPEv8gpeOGYkRD5wxWVRZ1Bcrm++18P2qKGBCzRabqngRwLHJ2zUjS33e/9sL
         YqXLWyHBKgH96kT95xOhJkSid0SSazwPHDHO0KAzbeo+NYx5lRh6aK4hJnr4Pki87DuI
         G9bNl70zunYV4NKfkOFABHsdT4e80BHYkRqGnwKjj4ALRX1wvZ0FauOpJ/WCtnxlsuvz
         QSdg==
X-Gm-Message-State: AOJu0YzX1hF73Opqhk3Cz0ar6nxEqKnv/mhk+sD+C+4Sr++J/rao7LfS
	wOhUrJLoG1oaEnFjEjJwPSpK79Lp9kIHx4MBstwEk9tXedRiki8PsAahXL1f
X-Google-Smtp-Source: AGHT+IH9Wr+CH05OPKaGQP4++ZmKDkhuCGCWX45mI/6j/J5DhZZffwtmE55hkOY2C0d8s1EBb/SfwQ==
X-Received: by 2002:ac2:598a:0:b0:50e:dc99:b9d4 with SMTP id w10-20020ac2598a000000b0050edc99b9d4mr1003476lfn.44.1705862495052;
        Sun, 21 Jan 2024 10:41:35 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id f9-20020a193809000000b0050eca2a50f9sm1728576lfa.277.2024.01.21.10.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 10:41:34 -0800 (PST)
Message-ID: <d1529d10-861c-6fe9-c27b-722405895ae0@gmail.com>
Date: Sun, 21 Jan 2024 20:41:32 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 20/34] kernelshark: Fix potential memory leaks in
 libkshark-configio
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-21-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-21-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/14/24 19:17, Benjamin ROBIN wrote:
> Allocate a new kshark_config_doc only if the format is supported.
> 
> Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> ---
>   src/libkshark-configio.c | 74 ++++++++++++++++++++++------------------
>   1 file changed, 41 insertions(+), 33 deletions(-)
> 
> diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
> index 9a1ba60..853e056 100644
> --- a/src/libkshark-configio.c
> +++ b/src/libkshark-configio.c
> @@ -675,23 +675,25 @@ struct kshark_config_doc *
>   kshark_export_plugin_file(struct kshark_plugin_list *plugin,
>   			  enum kshark_config_formats format)
>   {
> -	/*  Create a new Configuration document. */
> -	struct kshark_config_doc *conf =
> -		kshark_config_new("kshark.config.library", format);
> -
> -	if (!conf)
> -		return NULL;
> +	struct kshark_config_doc *conf;
>   
>   	switch (format) {
>   	case KS_CONFIG_JSON:
> -		kshark_plugin_to_json(plugin, conf->conf_doc);
> -		return conf;
> +		break;
>   
>   	default:
>   		fprintf(stderr, "Document format %d not supported\n",
> -			conf->format);
> +			format);
>   		return NULL;
>   	}
> +
> +	/*  Create a new Configuration document. */
> +	conf = kshark_config_new("kshark.config.library", format);
> +	if (!conf)
> +		return NULL;
> +
> +	kshark_plugin_to_json(plugin, conf->conf_doc);
> +	return conf;
>   }
>   
>   static bool kshark_all_plugins_to_json(struct kshark_context *kshark_ctx,
> @@ -739,22 +741,24 @@ struct kshark_config_doc *
>   kshark_export_all_plugins(struct kshark_context *kshark_ctx,
>   			  enum kshark_config_formats format)
>   {
> -	struct kshark_config_doc *conf =
> -		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
> -
> -	if (!conf)
> -		return NULL;
> +	struct kshark_config_doc *conf;
>   
>   	switch (format) {
>   	case KS_CONFIG_JSON:
> -		kshark_all_plugins_to_json(kshark_ctx, conf->conf_doc);
> -		return conf;

I agree that this code is a bit confusing. Long time ago we had the
idea that we will support not only 'json' but also other formats. And
that we will have other 'kshark_plugin_to_xxx()' APIs. This is the
reason to have this 'switch'.

Please keep the code as it is and just call kshark_free_config_doc()
in the default (error) case.

> +		break;
>   
>   	default:
>   		fprintf(stderr, "Document format %d not supported\n",
> -			conf->format);
> +			format);
>   		return NULL;
>   	}
> +
> +	conf = kshark_config_new("kshark.config.plugins", format);
> +	if (!conf)
> +		return NULL;
> +
> +	kshark_all_plugins_to_json(kshark_ctx, conf->conf_doc);
> +	return conf;
>   }
>   
>   static bool kshark_plugin_from_json(struct kshark_context *kshark_ctx,
> @@ -867,22 +871,24 @@ struct kshark_config_doc *
>   kshark_export_stream_plugins(struct kshark_data_stream *stream,
>   			     enum kshark_config_formats format)
>   {
> -	struct kshark_config_doc *conf =
> -		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
> -
> -	if (!conf)
> -		return NULL;
> +	struct kshark_config_doc *conf;
>   
>   	switch (format) {
>   	case KS_CONFIG_JSON:
> -		kshark_stream_plugins_to_json(stream, conf->conf_doc);
> -		return conf;

Same comment applies here.
Thanks!
Y.

> +		break;
>   
>   	default:
>   		fprintf(stderr, "Document format %d not supported\n",
> -			conf->format);
> +			format);
>   		return NULL;
>   	}
> +
> +	conf = kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
> +	if (!conf)
> +		return NULL;
> +
> +	kshark_stream_plugins_to_json(stream, conf->conf_doc);
> +	return conf;
>   }
>   
>   static bool kshark_stream_plugins_from_json(struct kshark_context *kshark_ctx,
> @@ -1019,23 +1025,25 @@ struct kshark_config_doc *
>   kshark_export_model(struct kshark_trace_histo *histo,
>   		    enum kshark_config_formats format)
>   {
> -	/*  Create a new Configuration document. */
> -	struct kshark_config_doc *conf =
> -		kshark_config_new("kshark.config.model", format);
> -
> -	if (!conf)
> -		return NULL;
> +	struct kshark_config_doc *conf;
>   
>   	switch (format) {
>   	case KS_CONFIG_JSON:
> -		kshark_model_to_json(histo, conf->conf_doc);
> -		return conf;
> +		break;
>   
>   	default:
>   		fprintf(stderr, "Document format %d not supported\n",
>   			format);
>   		return NULL;
>   	}
> +
> +	/*  Create a new Configuration document. */
> +	conf = kshark_config_new("kshark.config.model", format);
> +	if (!conf)
> +		return NULL;
> +
> +	kshark_model_to_json(histo, conf->conf_doc);
> +	return conf;
>   }
>   
>   static bool kshark_model_from_json(struct kshark_trace_histo *histo,
