Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863BFDDBE
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183930; cv=none; b=lTc706NsZlWL6tWaE2rQthvp7I7IuxBJMbQyLU8TPM6IGHpX+aasy6xRu7s/lIfg4XZlV8f41Wbmu42EKZ49zOzQH3NFiY1uG1OZ2CPtxXVsCfBxTc2bLLffEz/3LvuNBuFn1ar7NFEfjSUboNlvsM3t+H1zLCG+eICY8pIbFZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183930; c=relaxed/simple;
	bh=baeOsJ3JEKvtRfGvAyWeFf3tcTvTOuDz5fpnsL4GqGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GR6qlI9ITK7pSG2jVg71ARzOqTYPBubL91Dna3soV0odfHOqiA8UobSliGjhndnHJWgR4rbk0i1Yyj9IMxEmKaIo36ZFOYObXPpb+gMTnSJOfTKMZzpvknbWKK/o8jf15JB7RB31b1Alw2Et+dnd71G4LlbgbawM9mydcICUBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OuIYMGJj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OuIYMGJj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5L7t55clJsGteQSd8bwCsupDgeWds8T78bYU3VkJcLc=;
	b=OuIYMGJjtgvCG+yTIKjhkYvUfRUXTsrU/Fm5bOzMNhkPSUJ3dioT/iVWfx05iWaImYJRwm
	WiRGBbNQ/YGzfaWuMmTsIGz7vyxiSGaFVcKmXuUnkkjtz9nhKcLGvbarsrMeKuf3zIZdPh
	OxQIusEWRLQ5zx53KW0v3jORrSh1o5c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-enXv0so1OoSTFeTCLCSXng-1; Tue, 29 Oct 2024 02:38:43 -0400
X-MC-Unique: enXv0so1OoSTFeTCLCSXng-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-431518e6d8fso36863205e9.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183922; x=1730788722;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5L7t55clJsGteQSd8bwCsupDgeWds8T78bYU3VkJcLc=;
        b=b3WBhTYn2VEsOoY3Zx7F39aZrKtKD3ywoxLHTbZpfZMTeXgts2TXwGh2iD9aom9VAH
         Hibot1YO/nBIyMjwTh6Rd+bgBbJIhVkNP8cFUde3aBa3KGRsHpP+kl/g5ba1wrLIYOkZ
         2rO2IVtYz0N1c5ZhlKdfXgrCea3D4GmZbIsmJDPMOTFJKDXF48Mz+dn8PnIa9AJ/q+4x
         RDL2iTxNUJgS1yNxw2ghXu5MGK4oO9HSAx/iuK83p8SEU/YB+FUtqakJJgvAPhkXgnlH
         DevDY2SmntvTq11gq0vPgU32FK5/UQyK2V5uKEVh/b23YmYVjEvjXyVJ2G/krmRDt3Bl
         Jyrg==
X-Gm-Message-State: AOJu0Yx/uYctm4lWNwS1cfAsuURF7Q+QrvEncXBJl2DwKm5TM8goEF/7
	lJF69wIYjh5KMmesNje5W5RmAgMFQblOi7cZzEXa/SOH5Q1lGj4lBoMRE/kPPWxEmDpSblIbYix
	7lq2Pkd/e493K7l6VCJWNmDYfxz88KXESEj0afjFSPo9kNeFV/1C9TR+Xe0ZUBvkrKoV0
X-Received: by 2002:a05:600c:4f01:b0:431:5f1b:a7c6 with SMTP id 5b1f17b1804b1-4319ad361b0mr82231345e9.30.1730183922085;
        Mon, 28 Oct 2024 23:38:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6Tlu/qyNSCCkMw7KyOCwCSaH55BodJa8HwTqXHGIsZGPLJR1pKPRyIIs+f9wLlSDEfkEC+g==
X-Received: by 2002:a05:600c:4f01:b0:431:5f1b:a7c6 with SMTP id 5b1f17b1804b1-4319ad361b0mr82231225e9.30.1730183921769;
        Mon, 28 Oct 2024 23:38:41 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b55df56sm162537335e9.10.2024.10.28.23.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:38:41 -0700 (PDT)
Message-ID: <8bfd69b0-ba61-4935-97cd-f3bf6260c9d5@redhat.com>
Date: Tue, 29 Oct 2024 07:38:40 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 34/38] trace-cmd mem: prevent a memory leak in trace_mem()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-35-jmarchan@redhat.com>
 <20240717215329.0f9d2f02@gandalf.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717215329.0f9d2f02@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/07/2024 03:53, Steven Rostedt wrote:
> On Wed,  5 Jun 2024 15:40:49 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> --- a/tracecmd/trace-mem.c
>> +++ b/tracecmd/trace-mem.c
>> @@ -555,9 +555,10 @@ void trace_mem(int argc, char **argv)
>>   
>>   	ret = tracecmd_read_headers(handle, 0);
>>   	if (ret)
>> -		return;
>> +		goto out;
>>   
>>   	do_trace_mem(handle);
>>   
>> +out:
>>   	tracecmd_close(handle);
>>   }
>> -- 
> 
> Would be nicer to have:
> 
> 	ret = tracecmd_read_headers(handle, 0);
> 	if (!ret)
> 		do_trace_mem(handle);
> 
> 	tracecmd_close(handle);

Indeed. I'll send an updated patch.

Jerome

> 
> -- Steve

