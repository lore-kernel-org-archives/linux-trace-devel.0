Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761372582
	for <linux-trace-devel@vger.kernel.org>; Thu, 20 Jun 2024 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873368; cv=none; b=TObMA+2SgBdozgGUG6cGbxj42jzg2Fc2pC3gX50TL39dB3dKL4fQEv7tooa7pw1+Hd49MlRejKyIfMH/Huj1b7lr+87dkPDIWbEdI3wUqN6VWTRz6G9BNNI9F5DY/KtAChmopWy4zCydORPrOw3j7buXWocC7LEW48d3uW4Lwjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873368; c=relaxed/simple;
	bh=S1gGHhUNA+OfOEY/J+6W07mOw4VFlvnbojwZnRiM608=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=FBeQ/QUnxiH0/qaV1NW1F7HnulxvS1/3FPyjMLTJkAepFtZqiQ3bnSPafeGCcB9YbmoXuzJZksJmpHjGowSf4smj8M83BAK/GYxLN4d2Tly5mdT/3Lnfrvc6k8j2HQP6g+dT1Vv+QuedUaODhAWOiNcx9mW7T78aqeBupRFtLaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wjfa6Emg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wjfa6Emg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718873366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZlIJU5Kpryr5ONYoUJ/QwsXlNqvGp3GYd0/umoCuMmU=;
	b=Wjfa6EmgMKC6lcR/0so0Dd3xIJaK8HaVVXj3BcL0EFe9IC7XdufE09kwDVcHcwnQPg0wW6
	x4xoEqboGdgBXmxVTR0heQXrVlGR6orvnbv3HzQOL0BYwL62HjMjA6kuLVRp5ygrvxZQxi
	/DRbuuSpq8KEVOGnJH6PNTD+WYdoAYg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-4l4wOGptNSa8ToCE6PnI6w-1; Thu, 20 Jun 2024 04:49:24 -0400
X-MC-Unique: 4l4wOGptNSa8ToCE6PnI6w-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-363edcf12a3so336159f8f.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Jun 2024 01:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718873362; x=1719478162;
        h=content-transfer-encoding:subject:to:content-language:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZlIJU5Kpryr5ONYoUJ/QwsXlNqvGp3GYd0/umoCuMmU=;
        b=v1bPh3zzXoABKjld6g7Y4iRvSyyCEsw7FL/hmNhNq6EzOy9L8f+oqGPLbV8gKGhYRU
         oQwA8AWts2v1oQh3UKQGqaIz90HDAxaIxezgkhf/VpNJxvImQlo1SWym5yNawjXr0dus
         Idq8FPFSz/6beVrSAKKbqEAgffXmLQ8hEwV5WFkda/F8lm6xMSJCN7NixQtJbUWyNxNP
         t+8Mxvt42BwEFL/fqoleXlXnfZPn9gTxCHDIDFxxjUO71NO4CcYowtar3uve9QsbMq8x
         cSasR6yO/RL39rnKAY2z18GvuMKKzwjJAgbNaYX/ItX/L3phjYz+/AnYIHVTdSXSZU51
         HPYw==
X-Forwarded-Encrypted: i=1; AJvYcCXTUweIsfxexqMGpSh1pON+oU4MeZZtD3uAYFBq/x5o09ek3iMxRTgguCcd1Q/IByyEwzSLPjW7DJ3kWmGrfilw26O3YhmtZR4YKog7BuVPHJs=
X-Gm-Message-State: AOJu0YwrJK5q2umC5ccuvdY5JJ0H1cFeRYsEMy/PB628Q1z0qWC+dgTJ
	43eokjLyDVK1N4qlwHRe6Fs4j5w26XNhNr3hHeop/XzL6vduTQY1RzXyFqGLQnRcqCPe5HqRTMH
	i3cLX8u8xFitl8jwy7kzjJQr/RbYJwsalihCy9UBqX47QNv7AJ4S746GeLMwpsi3piaDRXASxGK
	A9
X-Received: by 2002:a05:6000:1146:b0:360:9d23:67f8 with SMTP id ffacd0b85a97d-3631998f12dmr3441993f8f.69.1718873362594;
        Thu, 20 Jun 2024 01:49:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqMksMchWSaCCAOIsDwhKzS+uvVwNbNcrJGXwN+awf9LxCtG1D6i2FBGTRGuY29RqunQ18ag==
X-Received: by 2002:a05:6000:1146:b0:360:9d23:67f8 with SMTP id ffacd0b85a97d-3631998f12dmr3441982f8f.69.1718873362265;
        Thu, 20 Jun 2024 01:49:22 -0700 (PDT)
Received: from [10.43.17.163] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-364a5b38996sm1353405f8f.3.2024.06.20.01.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 01:49:21 -0700 (PDT)
Message-ID: <112290ac-ee9c-41a9-8f20-17406364741e@redhat.com>
Date: Thu, 20 Jun 2024 10:49:19 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>,
 Johannes Berg <johannes@sipsolutions.net>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: trace-cmd library: suspicious SWIG instructions for the python
 wrappers
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Static analysis also showed the following error:

Error: UNINIT (CWE-457):
trace-cmd-v3.2/python/ctracecmd_wrap.c:18170: var_decl: Declaring 
variable "temp3" without initializer.
trace-cmd-v3.2/python/ctracecmd_wrap.c:18175: assign: Assigning: "arg3" 
= "&temp3", which points to uninitialized data.
trace-cmd-v3.2/python/ctracecmd_wrap.c:18188: uninit_use_in_call: Using 
uninitialized value "*arg3" when calling "tep_plugin_kvm_get_func".
#18186|     }
#18187|     arg2 = (struct tep_record *)(argp2);
#18188|->   result = (char *)tep_plugin_kvm_get_func(arg1,arg2,arg3);
#18189|     resultobj = SWIG_FromCharPtr((const char *)result);
#18190|     if (SWIG_IsTmpObj(res3)) {

AFAICT, this is because of the following line in ctracecmd.i:
%apply unsigned long long *OUTPUT {unsigned long long *}

IIUC, it tells SWIG that all unsigned long long* are to be treated as
output parameter so the wrapping code generated by SWIG doesn't bother
to copy it's value which would definitely explain the uninitialized
use warning above. Also I checked that removing that line produce code
that don't use arg3 uninitialized.

The next line in ctracecmd.i is just as suspicious:
%apply int *OUTPUT {int *}

I have no previous experience with SWIG and I don't understand what
the original intent was when those lines were added, so I don't know
how to fix it.

Regards,
Jerome

