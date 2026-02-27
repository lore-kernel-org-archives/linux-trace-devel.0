Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AB1369233
	for <linux-trace-devel@vger.kernel.org>; Fri, 27 Feb 2026 07:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772178312; cv=none; b=c3JssHd+csicwJKIxAgf+VyAsLEMOjRrlbzz1wgcYt8T+bfPzgPv77+Q8vm3GalieHqXyQI9KCVM7JY0okG45hVDVdxMJsmBc4tttF7Q/7HmpDDaColfpTPPgtXhELB1lZ8U6Px5Sk9YlNkCo4gKgV0Xl/rHRWI0vkp1TaIZoQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772178312; c=relaxed/simple;
	bh=SwUu+NAKlEUkpiTZDDTGpxNysECH/AriS5LRl6phWdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qb47Bo8x60ndtiFyjttrlt/MVmZC9EMVhGvf9xDayWQzO+SqgFUYH0DfTb1dAjy9wB4UUOotQUqk/MH5jMS32JtCJi3BAADK0mACGtJsjzIgSO381VnAcQJ4oLrE4cKhZ6ARSd1Pxq7W05xi0D+PUZQdjY0OBeCi2ii5mfm5/CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FykDFDOG; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FykDFDOG"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4834826e5a0so18361645e9.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 26 Feb 2026 23:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772178308; x=1772783108; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rxoqrIQHlXfnwsLGnTS2nr12rQ9Ig7eu0rnQiPEJeo8=;
        b=FykDFDOG6ExhhIz4N7l/+zR7EmHbmdHk9CQKdDJtt0W+3KevjEVhNs5R72YGcutCCe
         3ooGFzH10hqyAkPr7141Zko7Oh1ZyrcwgrrIBw+GT9SgHSLYo1hNhLK4waLXowYByYlT
         qHgWqciRGDIy95JwPXaolT4PV1/GM9294gRJy5gHiK9wtLFAxduPZlXyX+V9KO9V9SiN
         JmaWWBfbzu/sm/Ke9JYohVv2KB9yzGfNRN7B6aPVubReLgHn9ruOyOy2+Twi83XtxPYC
         UR0li9hXNCcsr46+COsw9PhzuPEIVyd+YaA46+HRdX41P6zgNb+LGi2/5lY4aw+qyFaL
         XFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772178308; x=1772783108;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rxoqrIQHlXfnwsLGnTS2nr12rQ9Ig7eu0rnQiPEJeo8=;
        b=B68y4UrhJIdI+4v8oFjV9d+MyDO6dESZ3PgV/Vt67kG31GcpBbUTWa4dAL3/xoxWEy
         PrVIJgr1Y2KHMnHF68mINSiBAfIftYN8EXwz5wSYlVheHt9UJxYqYSy8cdqq1Xi4g8Q9
         bjquNYprLJQDDHyvChHXala2pAOx0iMh6zWzIn3pa+Svad4twlsw9YspPOioYcYMLunI
         mdBJpJCILPH+K4rsAxiKWZHa6YhmNEwE4j76tLnTFt2Dr6Hr3m0EUExRnEPw1VGrRiPA
         bPReT1tnN+rDWlz+B2GmZ19XyYxOSguPg8+AWXuJGyqHHIEG1IpTFL/y8f8OZKEZzllx
         IT9A==
X-Forwarded-Encrypted: i=1; AJvYcCVs3a44Okp1jFlxVFMCMdYN/vkNQM1M0JhyVLn7x7vDk3PEEvybDSug//ZvWPG9JpT5M5T5PFEOJvowJctKb1dNfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxB9O03tc3zPMTlcGLAn15mmqcWaxLmgMpavGtZvWDEa/8mSbNz
	Kqmo4YHqMxwAdeSQKSA+fUyQQoDH/kwhyU4+pHTkIaSTvDi0kF2nwjwsjywonQ==
X-Gm-Gg: ATEYQzwQaeFv6xZOtDHOVsglXmES89cMsw9yDfedNv4SeVH0JzYRSs2Ix7x3JTEStxI
	mZAlBUEDNrhVAY1eqPm3sIZYu6AtXBxcyJ6ak+q8hJOTWRU699HMTXZrgF1fagHw2y4WJRLuaN5
	t6G7EEQ9FXRPwQe0lkc3++0+vHCFqz6jFF8huRaFwpZUVC15D689kXD5tguLMw0vhCXvMaCaXDl
	e3YpnMDoR6wrOl3wieo30MAXbBmNCamit9WNb5tr7dJUwgQ/qTGBqY9NGWSj6V0PuenJg25J1qB
	fwatHTORnJLxkwZ7uiU/Ju44acGP+XvcHnQLyxibxi/oST0DNalwiYp0SHqlsX7uav6D6Y98nP4
	43UPwF2Pa6WZVCEYhk0oPFO+tHk1k+2lGSjnJBNOKE4bXhBLef0PP2FOGFHGfIL+bSDKRRksmqX
	Hx54upUPeASeYFNv3zXrHIMRf91V8cCioB4NbV8iv+TMHp+NU=
X-Received: by 2002:a05:600c:314a:b0:477:58:7cf4 with SMTP id 5b1f17b1804b1-483c9ba7e58mr21646685e9.4.1772178307528;
        Thu, 26 Feb 2026 23:45:07 -0800 (PST)
Received: from [192.168.0.106] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b3474dsm87812385e9.1.2026.02.26.23.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 23:45:07 -0800 (PST)
Message-ID: <bab134df-d903-da46-37df-b564a3a58a30@gmail.com>
Date: Fri, 27 Feb 2026 09:45:05 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: Fix TEP filter array parsing logic
To: Ciunas Bennett <ciunas@linux.ibm.com>, linux-trace-devel@vger.kernel.org
References: <20260224170528.728883-1-ciunas@linux.ibm.com>
Content-Language: en-US
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20260224170528.728883-1-ciunas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The patch is applied. Thanks!

Yordan

On 2/24/26 19:05, Ciunas Bennett wrote:
> When saving a session with more than a single TEP advanced filter,
> KernelShark triggers a json-c assertion:
> 
> "json_object_array_get_idx: Assertion
> `json_object_get_type(jso) == json_type_array' failed."
> 
> This is caused because the code reuses the `jfilter` variable inside
> the loop to fetch each array element:
> 
>      jfilter = json_object_array_get_idx(jfilter, i);
> 
> This overwrites the original array object. On the next iteration,
> `jfilter` is no longer a json_type_array, causing the assertion.
> 
> Fix this by introducing a temporary variable `jitem` to store each
> array element, leaving `jfilter` to point to the actual array.
> 
> Signed-off-by: Ciunas Bennett <ciunas@linux.ibm.com>
> ---
>   src/libkshark-configio.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
> index 88c2c9a..568ec73 100644
> --- a/src/libkshark-configio.c
> +++ b/src/libkshark-configio.c
> @@ -1528,7 +1528,7 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx, int sd,
>   static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
>   					 struct json_object *jobj)
>   {
> -	json_object *jfilter, *jname, *jcond;
> +	json_object *jfilter, *jname, *jcond, *jitem;
>   	int i, length, n, ret = 0;
>   	char *filter_str = NULL;
>   
> @@ -1548,10 +1548,10 @@ static bool kshark_adv_filters_from_json(struct kshark_data_stream *stream,
>   	/* Set the filter. */
>   	length = json_object_array_length(jfilter);
>   	for (i = 0; i < length; ++i) {
> -		jfilter = json_object_array_get_idx(jfilter, i);
> +		jitem = json_object_array_get_idx(jfilter, i);
>   
> -		if (!json_object_object_get_ex(jfilter, "name", &jname) ||
> -		    !json_object_object_get_ex(jfilter, "condition", &jcond))
> +		if (!json_object_object_get_ex(jitem, "name", &jname) ||
> +		    !json_object_object_get_ex(jitem, "condition", &jcond))
>   			goto fail;
>   
>   		n = asprintf(&filter_str, "%s:%s",
