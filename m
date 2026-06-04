Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4EE26FA6F
	for <linux-trace-devel@vger.kernel.org>; Thu,  4 Jun 2026 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780567073; cv=none; b=c/oYUc1gjf3CEffgc+8HrjLBKBh+1t2c63rAbq/+BnqPJqB2jrFdgt01wtEYvaUlwige4CxkKs+5r7Ve0nhrejGCKJEE84/wy526IiNcL/IO8sbbUsgnAYL7IuFLOCOQ5KTCeeznlty5gplU6c4YSGjhgjCOJS6htAttuwfBxQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780567073; c=relaxed/simple;
	bh=miZc3crmgI+nF5mBNL3eoWs445MRIF/c1uqT0dPLYec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IpZ5mJjj4nbsDZEfEZXR1PciRl7UBoqrA7h3MXHDMuA/Z9oVrS0tz5qh9oBGDtJyvVvNI/4ruvnHJnZ5lyYUBqMLhls79+oJKXjRlNNv6vs5AmLDxm4PUUDOh+po4vmq6FAQQ5RnfNudVL0aSqfEtuLNPeDirrHKotaeQp+JiWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SK+ezIoz; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SK+ezIoz"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso3986835e9.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Jun 2026 02:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780567070; x=1781171870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pJKnVHzxi8TCMTA3+5JvVwS+QmDA4+1hZSH7usDkG4=;
        b=SK+ezIoz/ZldKHAs+uJp9Z3wtgc/PKA4gZJRfnCT0Dhy0HxPCA7fTOccOfkqjmdoht
         rJQ0bH7S9aMbQ1ZPU5zHmq5GRfgSmflIrcKq2ux5XzVNM/P2Z5sMjDR69HQ5n9e83Llo
         ek6NLo2+qEfBrsOkzrTC3gO//sXzFu5WJdgD8PVF3iYevmhyPzKhPmoI0t1OnhpzzPN8
         MeXIC92/gvYHWLlUCI2+Gyk+c5+MNELGqKxKuMUAvO6AI6a3PYVJ6tVTDK+/NWVtzNP1
         E9T6VnaHM/5muq84mKzBtNVG2fxy6p6vchOjQkUB8lsHF4DeRRXnDfk0OeqHXTmSIfJn
         NMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780567070; x=1781171870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0pJKnVHzxi8TCMTA3+5JvVwS+QmDA4+1hZSH7usDkG4=;
        b=DZoW+rEf7/kWuPEBgqTusHJeM2Nzt+l7pvRbO5BoTX4FfM4JCMZ/z7LYeitjdI7a/T
         TVRkqoIZHWlQPuF0a/J/O/D39Aq9mn1DNFBBJCvzRzHj2pK2FDtjxNuVjQ1rASJ7WWtx
         cok/q4iWU5HriAKDKzoqHWAg6inB8D+bSm+dYvgEbmbXxLCw0ep4+mKJNktd1SBd1oCG
         Lu/KQRBr32hy1C0X3BwelduoPx+Fj/iERhYtHnAuqWsGMP6IO3osHTKjYinZPDNH0r5f
         tTVF20v1a7h4IQxXcmdf89PffPJ95b/hPDVhx7eGWyGJeyR9T+IWNZ+WFx35JFnFLstM
         XQ4g==
X-Gm-Message-State: AOJu0YwIzUV8pCML8ccM7qed0/CSuavmRmqRR9n8e1VwuhQSggyDGiwH
	8Pa/rLtVaDh154VIesnWTAFfLkTtJB48+No1EVQeNx3BRYdcohDH6BMb48Ibaw==
X-Gm-Gg: Acq92OGlY6mYn6mfJyz26vZYmFt+kaLLrcRETOxwHKTt858ts3hDChH/dlIUtwVGiWD
	I9DWyVj9M10HFUZi/81mSv8LJpKyKa7wFMdqfQqXExiPH0GmJdyjNvzx4hrgKU2nLC/iZfEsh44
	/dc84XrjW3sOq3GBVfCwt7xThhemYEjip9JzY6J4lWkFef+FpkxnGVs4oaPR/QUptR59EchfjQ1
	juDxA7XEPY5V52vy3ucwl8iuwjsWzkXFlTHYYmvF16yAyr8jEx1kjYDDeGN654F2KF5wsOKmoaD
	twguDtoo5TWwcpcVRyRg4jECsBHxdeuoL21couxJR72UhOPLIbL6IGrI+N8ZvHIlyqMg3dd85MX
	7dv4DWru/BGLPZdcQ1NFu7+Oa6tTQIhHlFZULCdi0k6MD0sZm3y7yA9dZVk15E0DFL5L7+7L2oL
	Dx3B20ORsD0iZh9AGvAm/24e5KwGQhn5yTZMDQ8l9DdzWAVlj5o4os2rC2ZA==
X-Received: by 2002:a05:600c:1f96:b0:490:53d3:47a9 with SMTP id 5b1f17b1804b1-490b5e7962dmr112445585e9.3.1780567070040;
        Thu, 04 Jun 2026 02:57:50 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f368e9fsm14563949f8f.37.2026.06.04.02.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 02:57:49 -0700 (PDT)
Message-ID: <914607e6-1a51-e872-6383-292efecec61e@gmail.com>
Date: Thu, 4 Jun 2026 12:57:48 +0300
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Documentation update to KernelShark
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, helpdesk@kernel.org
References: <20260529115528.1d0f92a5@fedora>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20260529115528.1d0f92a5@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

I am very happy to see a patch from you :-)

The patch has been applied to the repo.

I do have a PatchWork account. My username is ykaradzhov.

Cheers,
Yordan


On 5/29/26 18:55, Steven Rostedt wrote:
> Hi Yordan,
> 
> Can you apply this patch to the  repo:
> 
>    https://patchwork.kernel.org/project/linux-trace-devel/patch/20251031115513.41b86970@gandalf.local.home/
> 
> Also, you probably should have your name added to the PatchWork so that
> I can delegate KernelShark patches to you, and that will make it easier
> for what is needed for KernelShark.
> 
> Do you have PatchWork account? If not, we should get you one (I Cc'd
> helpdesk@kernel.org to let them know you need one too).
> 
> -- Steve
