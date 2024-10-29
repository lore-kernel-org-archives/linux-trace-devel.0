Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F32010FC
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730184014; cv=none; b=AqO+jPNuBpHFnNyx3Kc/RstN7kpjWeTm7Fiou2hZGvJYa8lwtz42NnrZ7YrDxYIm3zjiPRUuYuqbj/3aNKo5SatlzkM7b0OniWuWS2UvLF2l68GHjhJBGEEA9EY+I4THpW56YZ7vshIyF0y0E12DF8+7RL8lg8TYTm/rW98nW1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730184014; c=relaxed/simple;
	bh=pM5Z2FYWO5NKDI0MhHdjzK22ZrgdJN7yFCRemIBHE9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rU42xmJjO34B1mMKoWqetKJ9Pr0/LGzPmIueqYFVda+mC71qydaEHY/ncIf3uikDQ3q1qcY1jxIP9btFS2JX5dyij5BotqwUM9/vVgrbTh0ZfwRA5GTrARhhBlMHnM44gaMarVMYxiDCBfTGMEvKirPV0pvMdjF0kbcko8FhYj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikX8TOfN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikX8TOfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730184011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ynB+MtfdMOZeOPyfaUKCQC7/naSAZ3QyOPK8r4teXe0=;
	b=ikX8TOfNH88hIC2CRYg6CiqVm2RdgS7XZsJPzR/edM+hnWlJoRCj6yfdKze8+kvh4i4xlK
	mmEK5v9HJ3rbTzsyaOiAZvUoyAD8QWiDTEBPWGclN1Htv8DhzaZ2mCpTBOVT/ACmyaoFQS
	o/JrrccRsU9LuK+FPNjcDiMezXVd9R0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-3-ocb4uEOaix2RSiEkHhEw-1; Tue, 29 Oct 2024 02:40:09 -0400
X-MC-Unique: 3-ocb4uEOaix2RSiEkHhEw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d531a19a9so2692197f8f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730184008; x=1730788808;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynB+MtfdMOZeOPyfaUKCQC7/naSAZ3QyOPK8r4teXe0=;
        b=vqM/t9w1z+r9qSFxjUu3+zAkepeEZChEprMzunqDHUCskHAcN/URFD0LL+IFI1q2VS
         6YNqIb6sr5yYoyiX3hZOq+gcKZpKTEjcaXlp2RhB0Q3bk3Z+im9pQxagrEq1UXKg8QML
         e1bG3AKWfWQptRQCA9A11QrODjaro3hDmEZ6UDVVRN6avCtTsKSxrLoQfW3xWmW8dDJS
         kGGk1PPQZPeX6kAcXtdEXrWLZB0rLflB1RpDSoNpqaEbnhXoRljcS/CjXnR3cCb8eKyE
         Q68yCO3d4Rfzn9CII6ewFcDDX9XptcjX+J127QjM65Mk6zKn9liCMChqT7FsxiL4LTdg
         wsdA==
X-Gm-Message-State: AOJu0YyNQs6txx5tfO3tcCfKF8fCfZRtLoWn3qiQKIFVjYHI8bjFx1ms
	PdZO/2Eq/gD3tVVrm8DKCiqVLhnIBRgzw+1yphfNdSrTDa4P8M0TPiRGI5/tzIY6SNcP8rFzjnZ
	HQn9F7YbauYIDG7TFftfMDTE0DYdmvh4iaVLriVTl+pZ2Q0fDzfmj4UzY+8xZRdWgiHLAVcEdBB
	I+
X-Received: by 2002:a05:6000:c92:b0:37c:d11f:c591 with SMTP id ffacd0b85a97d-380611372d5mr7723763f8f.17.1730184007708;
        Mon, 28 Oct 2024 23:40:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCtwmIRXUkb+BS23EiR2fkmuuw233ICsy7ZTvraxnniT5H4MOLjO+ByCsp+dn8sBr5q73r8w==
X-Received: by 2002:a05:6000:c92:b0:37c:d11f:c591 with SMTP id ffacd0b85a97d-380611372d5mr7723755f8f.17.1730184007375;
        Mon, 28 Oct 2024 23:40:07 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b5431c9sm164154735e9.0.2024.10.28.23.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:40:07 -0700 (PDT)
Message-ID: <13866552-e15e-4df5-b6d8-29dac64c52c1@redhat.com>
Date: Tue, 29 Oct 2024 07:40:06 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 36/38] trace-cmd record: check the length of the protocol
 version received
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-37-jmarchan@redhat.com>
 <20240717221132.25ab21da@gandalf.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717221132.25ab21da@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/07/2024 04:11, Steven Rostedt wrote:
> On Wed,  5 Jun 2024 15:40:51 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> In check_protocol_version we compare the protocol version string with
>> the expected one ("V3") with memcmp(). The received string could be
>> longer than the constant string used for the comparison. That could
>> lead to out of range access.
>>
>> Check that the received protocol version is not too long.
>>
>> Fixes a OVERRUN error (CWE-119)
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   tracecmd/trace-record.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
>> index dc3e5285..c3118546 100644
>> --- a/tracecmd/trace-record.c
>> +++ b/tracecmd/trace-record.c
>> @@ -3810,7 +3810,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
>>   		msg_handle->version = V1_PROTOCOL;
>>   		tracecmd_plog("Use the v1 protocol\n");
>>   	} else {
>> -		if (memcmp(buf, "V3", n) != 0)
>> +		if (n > 3 || memcmp(buf, "V3", n) != 0)
>>   			die("Cannot handle the protocol %s", buf);
> 
> Actually, we may add more to it, so this should be:
> 
> 		if (n < 3 || memcmp(buf, "V3", 3) != 0)

That's definitely more future proof. I'll send an updated version.

Jerome

> 
> -- Steve
> 
>>   		/* OK, let's use v3 protocol */
>>   		write(fd, V3_MAGIC, sizeof(V3_MAGIC));
> 

