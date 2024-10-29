Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1251E0B93
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183650; cv=none; b=tOeo0Sbg9XO1rr+rFKyeyTnVtG9IIGlDHqB8ARBgDuwYqNjdTK9cHRAOgWqr7rFIZOcTgDaa7I3ByJtFuvVVq/Sqm0NQmBBCa99YEPnQJx5I8T5JEqiVD8vLSrp4XNXFq55ALKRojEP4GkN6LpW4fc9ZwYMZtYJaY/8m9kAZq7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183650; c=relaxed/simple;
	bh=m3rClkSd/MgadrtxDIFIsq/pJLfXdAtGG8qJZO4Sai8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DPCfyNVUsVzi1TXgS+HlRowHyhNSQ16nCPhoqLr/fTA98EuKoLxl7F9rBIjW+wze6Ki/XhMZpGXL6g7bBfrU5DmicDVA9S++FrlbnSbkWGc1SIFNAhPKvE1UXEIp09amvQciHIuhtSOGBsnDowEirrI1BkCAZXkjsG5rTdQCFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGw5pMvu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGw5pMvu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1U1+gQO7f2XSDUu2eBTztDHTL4L1iaib/cTRCq2UMUw=;
	b=SGw5pMvu4q+e5Q5+IhABrEdFKpco1ygjXvr5KArwpXU+UPSrLbXJSElAwQauOXaqJqeZMf
	CweJIxIItMDrLG3bMqeVGqq5r+mgBJM9JpDt/jfz/ppZWsTC2pAQ2boyedeOFxKQiISfzC
	f+8QL+1xzwop6ipCyTMD+4xg92JUkog=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-aNZJTwXZPQ26MPXnSHQAeA-1; Tue, 29 Oct 2024 02:34:03 -0400
X-MC-Unique: aNZJTwXZPQ26MPXnSHQAeA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d458087c0so3573446f8f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183642; x=1730788442;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1U1+gQO7f2XSDUu2eBTztDHTL4L1iaib/cTRCq2UMUw=;
        b=Ik9pZkDrZsrl7PSlQppR5GZ2wUDH2TdPFAZ1cdScrLyUh+lE7q2F1v7Lr2VeZhr3Vn
         PecFKrq+76KVhNojt1gz4Ams8gN2w7P1pqOEjj8q5yAsUsQFC5IVv9qbghEvw38BTjjo
         PBEVO3XdcVYqXENbpTI5pkYsUFFGFOM86osQrx89847RaaOmeNdpUara3dBAM9oiUas5
         l/SQyiir1JTWKO0ewY7qt0pWn77Qjnlzbb6z0lEH8oXC5mAJ5pGlw6Df4Qp8gUjk2LPY
         THlm4qiZOkuSNL6QHjEnR2bG8gaK4Xra5WE8BLaSlAza5IT0HqC5Uuyo8Q/SreuXK8uL
         YnRg==
X-Gm-Message-State: AOJu0YzkdtJUST4tkAtUSXk4KvwePPPbWiUNKXBG0T6iWowxPbF9HH54
	SQwgv1IFn6UcM3U0XghUNI53LrCCAQFVOjh7tD3F3Sgwl/FDCaIog2NsXCtrPNKAH/tC1y5U+3V
	JzeQsujMfJaJUAmnA+5g2wr9DXhOERrKti/zmZnZmVzwCI5t6cA7vwhOsCOrCOhyt5ziZ
X-Received: by 2002:a5d:4f8d:0:b0:37d:34e7:6d24 with SMTP id ffacd0b85a97d-38162907d1amr573471f8f.18.1730183642031;
        Mon, 28 Oct 2024 23:34:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFow5NFi76Kmom2AX5Jitxu0LFTANwqaj1yKvtLWJc+utTj1Sq8CnszXFi4jAZtufO7DBtaKA==
X-Received: by 2002:a5d:4f8d:0:b0:37d:34e7:6d24 with SMTP id ffacd0b85a97d-38162907d1amr573459f8f.18.1730183641701;
        Mon, 28 Oct 2024 23:34:01 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b70e0fsm11559853f8f.73.2024.10.28.23.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:34:01 -0700 (PDT)
Message-ID: <084ba0c0-4e79-46c1-806f-1bb4fce2ad7d@redhat.com>
Date: Tue, 29 Oct 2024 07:34:00 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 29/38] trace-cmd record: prevent memory leak in
 setup_network()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-30-jmarchan@redhat.com>
 <20240717202504.492440b4@gandalf.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717202504.492440b4@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/07/2024 02:25, Steven Rostedt wrote:
> On Wed,  5 Jun 2024 15:40:44 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> Because of the again label, msg_handle can be already allocated if we
>> exit after we got a negative socket file descriptor. Free it there.
>>
>> Fixes a RESOURCE_LEAK error (CWE-772)
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   tracecmd/trace-record.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
>> index b4cbd438..770e775b 100644
>> --- a/tracecmd/trace-record.c
>> +++ b/tracecmd/trace-record.c
>> @@ -3903,6 +3903,7 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
>>   
>>   	if (sfd < 0) {
>>   		free(thost);
>> +		free(msg_handle);
> 
> As msg_handle is created with:
> 
> 	msg_handle = tracecmd_msg_handle_alloc(sfd, 0);
> 
> This should be:
> 
> 	trace_msg_handle_close(msg_handle);
> 
> But may require:
> 
> 			close(sfd);
> +			msg_handle->fd = -1;
> 			free(host);
> 			host = NULL;
> 			goto again;
> 
> I'll skip this patch.

I'll send a fixed version.

Jerome

> 
> -- Steve
> 
> 
>>   		return NULL;
>>   	}
>>   

