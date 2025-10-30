Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FD121CC62
	for <linux-trace-devel@vger.kernel.org>; Thu, 30 Oct 2025 19:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850917; cv=none; b=OOiuUPQ7ITr0bM43iteZiugfReEsrN7Gu5ggMHN2kGGP04/zn28ypQ0tXVONcXPmPJ50eJukMIzjXqcom60r8GxJ9A0hZcg/XT1hqk4C51Kf969bY6SKTtdjmwrhaPsCr7JPun1q2zR6dDGbyTVUEj3F6D81+Vq1CBT/0VRNRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850917; c=relaxed/simple;
	bh=oJJpW9P1U0Aj0zGQydgH18oZZq5EYFaqD6RUthF0DxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uKVbm78JiX6Wk1Yxn8xCv4xuH1m3Ce9eZfrestw5XRK4N59c39wTq6+puR9qhmUH6ibR2eY1DoqJyXrnXKQcRwXfLSmcUHtx78F/loisW/dmOO3eNSQ+hZrn9uSxmKbrpX8HxCTpkUkA1NTPUEU6xFUpTdz+7sLSMY+UUHxG/Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jndQZvqs; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jndQZvqs"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b6d6c11f39aso255755066b.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Oct 2025 12:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761850914; x=1762455714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smSqTsbaNWtPSDog860f3EQUmQeclbrv44ExGcinLx0=;
        b=jndQZvqsgc0woSZp9PBVDeg/lCP+6n3iS/CtVBgWbOLwgPIJ1jdxP6H4mw+0epzROs
         T7jyDpWFzai/9fXdq4AmnMDx2Yd6TpJUhK3EgpmCSKeeFC3E1TeSaO8s0P/mYEUlcp0k
         ueV4EJgEifVgQHLubTP+8jYKu+CsFOEyrB2QKBN72vI3GiqzQVQ3eGf2JRCz9Q3mRrao
         kdoOSYQFW530r/ay6KwQH9POOZ2dH5V4YDDWEf1w+rqgxBaZ9k9I8f6v9bQpA2dzjv9t
         0FCxpICwd2Qf18kMhHW5OXbKdyDZ2mZNxmDQ/oyJIc6SFhvyzUHRtGDBrZOVZnNmzVDD
         C+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761850914; x=1762455714;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=smSqTsbaNWtPSDog860f3EQUmQeclbrv44ExGcinLx0=;
        b=cafRhs4N7XAUedwVzBkEThrNx5fdKga/pWAOInqWcVqSBfne3D0t4Z+93Jhts+wxG3
         Skf51/Qb3lJJT1HjIlKqXJLBLLqqF/NGB1baglTCHL9KyhUJ38v6X5bBJq0uiyzb9dDi
         DggUmQcxkO+K7Zd8CDVtTNngby45IvJMVTPpwteFIU5z7pj7JdTB0tN+trK94NUVpzb8
         pFu7gKyXrT4m3QNkJs6NesPGUexWSsC87GxaHg37DfN9RirvOUQj9rzsMH9BvWyj18To
         cny+QSlSG/oaA8iDCVebRLPkNyLJfFY9rrWLL17gtHGhfIJ2t578XcyYE+HZCDSt2UxR
         IVCA==
X-Gm-Message-State: AOJu0YxtfNSA/7HGjmNrMjWHRg+sC3LYV9cVC2xSiXbD2N6xPPvVcZ3k
	vuFq7tN6Zr2p3KHTwj1tr0mic7fH2kd2/MW6Qwtr+ZLZnHzOLALjz0xVuBGIvw==
X-Gm-Gg: ASbGncvp0fgm5rYAdA5r82AABCmZp361poEqnuXzRfUxpa6VChpoX1QEUqgvMWwIFF9
	xyWwlMOCxXb3q4bWN9arX9+D/rTZPlb7H4ABUJm+c6aeH8331XrwC8yfgh1jzThbsfm9UIyLDHB
	RF7scklGwvfiZSgYsFsZzOggX5QayJPn6S/c2EA06hX/fNZP2+Dl4+ow1UGRIjU27apN8MwoiwD
	tUdf82TkYokKE24QK7yHNO29j4m+jnsDxWSC+dvLIMSy/yA2/mjamSNK2tvwH4bZ2L2x1JnxKGi
	08aYWBMqqe5u9QDeTH+jc2Q+uXKD8xLEgDQfB+pAmpVIbYWblOgcfIP4XVpejpMJ/hC6zJezSUD
	zfe2XcW5Vt9URxdxrBA4lEGu9wNyxG+3XHLAE7kTOKgaNLjMP/gQlLBGV4HI5bVnCxisY+HMH21
	rgkf3ttnC1SajdnCXQdbVPXytN
X-Google-Smtp-Source: AGHT+IFTiCHGNCHM7vk4ImyCjiRFy1UnU7Jlp98JMU/Az9d0FSblZ/u6jTTIrgyh4KD+x15l9fjZ/g==
X-Received: by 2002:a17:907:6e8c:b0:b70:51c2:6915 with SMTP id a640c23a62f3a-b70704bc375mr55742566b.34.1761850913883;
        Thu, 30 Oct 2025 12:01:53 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8541fb2esm1825151266b.59.2025.10.30.12.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 12:01:51 -0700 (PDT)
Message-ID: <23c206aa-b730-958f-8ff9-338efc25cc52@gmail.com>
Date: Thu, 30 Oct 2025 21:01:51 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: fix bug in the behavior of ksglwidget rubber
 band
Content-Language: en-US
To: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
Cc: linux-trace-devel@vger.kernel.org
References: <5c7a78ce-b1f6-4396-982a-8b884242d8cc.ref@yahoo.com>
 <5c7a78ce-b1f6-4396-982a-8b884242d8cc@yahoo.com>
 <f6ec9f89-a161-e596-79bb-ec21aaa1047c@gmail.com>
 <cba49bd9-5172-4960-a2ec-6bfd9078d4be@yahoo.com>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <cba49bd9-5172-4960-a2ec-6bfd9078d4be@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mircea,

On 10/28/25 22:27, Mircea Cirjaliu wrote:
> Hi Yordan,
> 
> I tend to favor debuggability, expressiveness and readability in my coding, even if it makes for longer code
> or seemingly unnecessary code constructs. I'll leave it to the compiler to optimize variable usage, I wanna
> make it easy (for me or others) to set a breakpoint or understand what the code is doing.
> 
> On 27/10/2025 21:51, Yordan Karadzhov wrote:
>> Hi Mircea,
>>
>> Looks like this is indeed a bug, however it is hard to reproduce. I had to do a lot of right mouse button clicks before seeing this misbehavior to show up.
>>
>> I will take the fix, but the patch itself heeds some additional work. See my comments in code below.
>>
>> On 10/20/25 22:00, Mircea Cirjaliu wrote:
>>> Accidentally pressing right mouse button while dragging
>>> the range will cause the rubber band to behave abnormally.
>>> Improved the logic behind range dragging to account for this case.
>>> The state of the rubber band will be reset on right click.
>>>
>>> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
>>> ---
>>>    src/KsGLWidget.cpp | 40 +++++++++++++++++++++++++++-------------
>>>    src/KsGLWidget.hpp |  2 ++
>>>    2 files changed, 29 insertions(+), 13 deletions(-)
>>>

>>>    @@ -262,8 +265,10 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
>>>        if (isEmpty())
>>>            return;
>>>    -    if (_rubberBand.isVisible())
>>> -        _rangeBoundStretched(_posInRange(event->pos().x()));
>>> +    if (_rubberBand.isVisible()) {
>>> +        size_t posMouseRel = _posInRange(event->pos().x());
>>> +        _rangeBoundStretched(posMouseRel);
>>> +    }
>>
>> I don't see the point in this change.
> 
> I needed a breakpoint there.
>

I understand that this change helped you find the problem, but we are 
not merging debugging code upstream.


>>
>>>          bin = event->pos().x() - _bin0Offset();
>>>        getPlotInfo(event->pos(), &sd, &cpu, &pid);
>>> @@ -291,17 +296,20 @@ void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
>>>            return;
>>>    
>>

>>>    }
>>>    +void KsGLWidget::_rangeBoundCancel()
>>> +{
>>> +    /* The rubber band is no longer needed. Make it invisible. */
>>> +    _rubberBand.hide();
>>> +}
>>> +
>> What is the point in defining a function that does nothing but calling another function.
> 
> Layering functionality, i.e. mouse events call _rangeBoundXXX() functions, which instead act on _rubberBand.
> For improved code readability, also having a properly named logical entry point aids in debugging.
> 

Again, debugging cannot be a reason for pushing code upstream.

Best,
Yordan

>>
>> Thanks,
>> Yordan
>>
>>>    int KsGLWidget::_posInRange(int x)
>>>    {
>>>        int posX;
>>> diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
>>> index cafc70b..8fcac55 100644
>>> --- a/src/KsGLWidget.hpp
>>> +++ b/src/KsGLWidget.hpp
>>> @@ -315,6 +315,8 @@ private:
>>>          void _rangeChanged(int binMin, int binMax);
>>>    +    void _rangeBoundCancel();
>>> +
>>>        bool _findAndSelect(QMouseEvent *event);
>>>          bool _find(int bin, int sd, int cpu, int pid,
> 
> Best,
> Mircea
