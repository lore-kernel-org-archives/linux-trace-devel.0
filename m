Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB517200CBC
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183817; cv=none; b=gbVMcZW5tvjVpaYpFTl7N4P7kgoO5gGUZIXyI/Mg0TOrJeZV7DaCcpGTTqKG/BI636HmI0+fMQAxOgOB0Pf5TQy8eps7TFNE208XF2Vy2KJCg1w2CyIC4ncjiCiDIexNn+JQhyvJdSLc1YRE0Y1VZbhr6wdiv4kRyt3J8EeEtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183817; c=relaxed/simple;
	bh=fEOn/5WkqT8Ea+1itN099jzBe1TmoD5GNV8LIZ559Yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N1ZXs20klRJIoodS9NoX3TtlDxj9zu8koq1y3SCrTA9TDB4DWfFvAUhKvEMUuTFl9+uvzIHpHd8wbx5zRw4qAKj4E0xQFQaAw0AXtnZMVCh7cphKu1UnJbR/VWuIAnIORnFlOJPZNb6ZdKP2YolP5E6wadJPgvgZUjmD/Lu10KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L47QClFm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L47QClFm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lsinm3624GNVz1PyvB1AXYZL+m3Kz/DLLfTd1Ud82Vg=;
	b=L47QClFmnDd+Vvva5Mu1NLEOp3/o/E2MKuDv/fBy8OIxGyMFu2BkAIxLbECCaEDrHPNi5O
	2n1RNa1t4HA6vRaFi9K2IfOn+fwRw2Su323qaVl0NMDouc92huNtWgGmamzqrshMGsDPES
	XdF9UeAYuzHmOpOWPWzfzjWgn8sat3g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-f92wMUonNmKkFnegM5gCJw-1; Tue, 29 Oct 2024 02:36:52 -0400
X-MC-Unique: f92wMUonNmKkFnegM5gCJw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315e8e9b1cso28464565e9.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183811; x=1730788611;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lsinm3624GNVz1PyvB1AXYZL+m3Kz/DLLfTd1Ud82Vg=;
        b=MNbETd6gwdy3OGDtl/+k0wWJPmKZ1Z4rdbjPIfG6Uw/buBMwAGqAYHymzZH1MTJgGx
         3a8zbWzUT/6kewrLZDDjbSvLdF0bbmT8W6U/+d878Sk3SLlpCUC7b0AHj0LDG9MpcRM/
         hFoQW9nW9kzxhh9DjU+BZDfzFO3B+mOfiBvKStuSqjcCeizb/Rb1hQr/Qi7F3qrNkg6I
         7+hi773FS9lntYWuv6+1rkkImzzwvDwEHWr/icnKlyeLEUfkRR6OHwLxD8DCgKz0g2PA
         Eie/GOUzR5WxghSh2bU5UfhkleBPCkAhr6qId7Eg19gpVS5JuTPM9tckrwTxG9IYOPCd
         fhsQ==
X-Gm-Message-State: AOJu0Yw1PMEAW5GmJ/xtgP4DwhBxm6sRjwnvKy1I+3jdI3xJOIhJEHPD
	I/LAG/AshhMAcfPuKdeXXrynetBlJXwZgfsSEEUEZ1E+XJQ71IzfCpCjebrhAg5t/MsPWftrY6i
	qo+9tpGs1Bgyuu+7eEZcQfH9WxdsoTRcHH95piNFf9eep8YNttrsMQlb0hOD7jcDfo2JPA6KRut
	F8
X-Received: by 2002:a05:600c:1549:b0:431:15f1:421d with SMTP id 5b1f17b1804b1-431b5636485mr6602695e9.16.1730183810840;
        Mon, 28 Oct 2024 23:36:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP7s7rgwsxlc6+DLTZzlI5QN7tX39BG/D+6ZFvuXNvCxAdKsea3r/8teXjTik1INqf5lHTcw==
X-Received: by 2002:a05:600c:1549:b0:431:15f1:421d with SMTP id 5b1f17b1804b1-431b5636485mr6602565e9.16.1730183810532;
        Mon, 28 Oct 2024 23:36:50 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b9279esm11555615f8f.104.2024.10.28.23.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:36:50 -0700 (PDT)
Message-ID: <122ae37e-1c92-4b9e-9ec7-1c7eedaca1fa@redhat.com>
Date: Tue, 29 Oct 2024 07:36:49 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 32/38] trace-cmd lib: prevent memory leak in
 tracecmd_create_event_hook()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-33-jmarchan@redhat.com>
 <20240717211647.2de08075@gandalf.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717211647.2de08075@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/07/2024 03:16, Steven Rostedt wrote:
> On Wed,  5 Jun 2024 15:40:47 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> Free hook in the error path.
>>
>> Fixes a RESOURCE_LEAK error (CWE-772)
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   lib/trace-cmd/trace-hooks.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/lib/trace-cmd/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
>> index a58b5356..47f25fb3 100644
>> --- a/lib/trace-cmd/trace-hooks.c
>> +++ b/lib/trace-cmd/trace-hooks.c
>> @@ -151,6 +151,7 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
>>   
>>   invalid_tok:
>>   	tracecmd_warning("Invalid hook format '%s'", arg);
> 
> Should we also have:
> 
> 	free(hook->str);
> 
> here too?

Yes indeed. This wasn't detected by the static analyzer. I'll send an 
updated patch.

Jerome

> 
> -- Steve
> 
>> +	free(hook);
>>   	return NULL;
>>   }
>>   

