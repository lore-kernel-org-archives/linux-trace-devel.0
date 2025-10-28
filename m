Received: from sonic305-22.consmr.mail.ne1.yahoo.com (sonic305-22.consmr.mail.ne1.yahoo.com [66.163.185.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C374502F
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 Oct 2025 20:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.185.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761684486; cv=none; b=AECBiMJ0QAs+QtfGsoOus/O/D5Iczp+V1PPsIRbxd8ceOu4fucU+UB79Ba2K3m+crTubhD0olUEgi6+Pqepw0qWNFE/2fnAdgsnqHMoYiFPQkIEawTxUfn7Dqw5NfQ0ZHyCViNBfetRS2HofxCjnMemtyPJsMW1kVwHRhERZ8bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761684486; c=relaxed/simple;
	bh=7UpwLvSb7IcYLKbtOkBNI2MkO+9j/rZbd4+tGhF/E2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=WSMHKS10IbpAMo8iWXtND65OrpIDU3RqrBBEXZxg+kSsxU8CkclrnCHvcweXSQllEzqjLBmr60+4bxS4ad2i2iKktjb6w+MzUmhaMoTLhSPlOg9ypw7NwhUdSz4GiZIRF8BCN9PIKha2weK1vuK4+mnqpIY39lEMg2H2jTyV8ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=bUO+f3fW; arc=none smtp.client-ip=66.163.185.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="bUO+f3fW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761684477; bh=rBYSrozK8m1dOvPMUYyW7/jbYfEnXdhDtfCosdp39Vk=; h=Date:Subject:To:References:From:Cc:In-Reply-To:From:Subject:Reply-To; b=bUO+f3fWeZ7mrBq4m6Jzgz905DxYlvQZH5Xn2v6x9G3B1Lc3qZK/C8fUaL23MgDrlBfyIMaCV5YmiS5nxeRmHwLkE3I5hEzTDFqOhKqzjS7eVEOhTUUHUglHN+riK3Xpd/rdpaQByx4rAqIbuE9rCeedLexbDNqMg5wcaohJOEVv8PzS+25RG9rBU+Dxl93Ev/MPbWhwMuZskcIyRBe1PzeSyY0Zg4RsUbbClOaccCejwLPno2KwYzjRj1uguZHEdY6hLPuxJFD5oRMvmS1F2NjYfH3nt3/Ajj6DS/iXZMNwuo3uKrkBHe3+lKReUFNOKomjQcNyZ8YoxJ24K0awvA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761684477; bh=pVyciwGZv+Jp9+ydwkeiojLcS+g2eQbl0NhlVqtl360=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=PYpJq87ZLEiGk0V4djavB1nbm2DaNAoMldoyUSWtCsylwk1/0zLgBUpNrCJ0Vf6ddjkk04zldDfxNgPxqt1KiLI/HYnwcbxQ6lzTKkFimCkrLQOX0EHsFOHBA9Us68KkGoGOHoUrTO2bZ3+B1ke/leKpxPoZAEekBZ3JhftJF0nntjtyX10ZRx8mSU7ofQOhlLdbUaU+uS289Ksm0YiAiJqvrBNZy7SvqmDSepb9tkbgZ/AVdjC6eOpUTNjwFTr+Pxwt0b57NyYlaFFnhkzVBwlyw3FzNW2sa0ab9ilwTQE+1tqa/QT1mhCDMisygxWm0+HuotYQYhsZyIq3013LUA==
X-YMail-OSG: 8_1RkLwVM1lthzfZN78ZFaJ5aADJfcyBin7KY7sltd_9NrVWVk_tTEg_sAxFuTi
 Lz.AVoB6jfsuybcoomwG7FlK1TwrsUbq0JaGkE_0Hndv4wxKFQYber8riHkb1ze5w3BGhzWGIIam
 cw4x2XFGbJcn0xdUKtfgnbOfa1diQnPLO0C7F3YA7XFGFhuq1F4juCwn3Sxayfun5rkns8CIDnPQ
 C_0p_Agi_Nj8ScJWnWoJRJ7A1rw9ht7Sn18dZ2XZvB2bkUav16E.0dDnOu8tszdMinGv13I7vyxP
 ZTX1UDi3F70Lr4asfcsc59vS_kICb5liJjfH9aiZj9n3t5cv4LCLVl.rnt7m4LnDkxPBy1_EAizp
 .u0zEVgLVXZ5oqoq1HamE_fIAu7jap60Dc1d7D6HUwZ7B0n9NBpHk9LjCPj3kpa43UnII4NlA9Pq
 YBSftIqncbD46p6pV0BkdvzTi68Me.QiUrHI1pOsqyEgBG5XFz3gGkp0f0InSUlnGmlE3rLhUo.w
 gRHf.bc.jguXv0VRddJKA.K4xeCNS0d1Tt47FBaJcBXEwJRX297Eapoh81SVrGBqlwwz0crWAaLX
 1MlhKq93ns7XXtvuXCyXGtT_ikcEU5Nf9Cu.Nm6YoSk1o9GoImIqceM7GlLsdAjkEfcFtcekJOWD
 .Y336PjrOeHte_yqHKG4vVKpJ9fFWxW6yqqRANriNnFBiFlhfSZFAzQVeHvvnZW.P0zcLpWXARxj
 EyuSZ3KurlitsESOmkJ5p33jOSfCsTLn4qyVryc.9nGw0DdBJbgUzbgloEhWz_HctvGAF9Mrg_Ec
 ZZihPeLStxCQZlpM4V75nA5s5T1_A1_cQFC7o3RVbavBu9Ukk8cUoQY0k7wMN3tziqFG1EaJF48b
 zoZ6QbYFydQN2TJMPVyjuodK4jCMI4OeGzlE25Knr.witNbXjGBIkA0APHsmQaVQN6Y0Vmaz6T68
 4oxe6h4SzGmqhxaqlboqweiIzwZnAGnAh9AddstBkm6DfsGUJBjRs_sseHqu0txnHcjHtTnBQAQe
 2dPMzwzibXMPIsE36tFjNthWm4T67Om6qk5ntt4kiNc4DRfqyb8mgd2jfDczcuPxOlDOEoWvB1FD
 LyxRWAKjoQbClxgUu75Uz1w34VHPjMyAiXXRD7TqclRzrKUJuWutI2Syab4wltP9z6OyuR8wC3MO
 Cfk4sglg_YPvBsANqTzo3novn3rY6.kRPoC5GaC2WBuhYoXIS5Q8f9etQr0FfLHjEmZaROpI.8ZC
 pDEzCNWBa0EpAaxKl9LPkmGHxZqDA354Bndrs3zq2UjSdzKVEBSpT0WLAsfKuAhQVZVW4AGZhvdD
 FPVhjRWUDko3uC2v6zhBWFcJLbamHnrqC6umxKGedbXRZGdpwDftAYRL7g1a3N4F.j0hvr95UNLf
 au0sBJ3nkEsQ1gKtEnQ2DPDlIUIQJRzfAS3iGKu_9KGGpoGOF3AHhEe2ae3fTuLceGwxu2yH4gAF
 MaaT5gXQP0GQT0ZVUOpNgP3q4P7H6qURRU2aU0Fr.l_Ob9KOg2Js8cN2i43_Ngoeq_32yoCAC5i1
 wK.GFfo5q4oKFa.fzzj6iPS4Hjwjp8mMhGY2a8Y9JsUNCxkN08uyoAh3oVF.SFkVAqfHwQCk3bF2
 NDRLonVNsaybaMxE7zW7ZtE_U0dY_yfWyozEYyniwBOagH65kSfg4O7Z.mBCUtB5PTrxOchtK7rJ
 yufydxTOtyOMYoelNPsskmWgt6S5sJCK9ihXy.4OPSudII0sEta_nmuYe6KTfIMG5Kud6hs6G6LP
 6SIIxaog6pPVuGWCVJ2xh_CSczv3qjGdxwhJsk9ZcAGOC08UPZDy.i1vt72MkUVspAmxpeb7dD6A
 Y.EDhg6ooiNrMBCS0C7OamUkYMuckPQWWFXK4W5S4kPyp45Zk2ebLzh4vevIh6_rK2agKOxe0KCe
 wxXJJ8hef2xPdhaUa5KJ.g3lTysDZ93cQxWW6Agp.AzmgC26ndLINdECAJpCyLnaxutlTDrqNMaw
 nZR8ziHdxs5j2IeuDnRbZ.3iwlCzGNS5b2cCCKd2QKROl9yEZG6F2xl0_NyPtJmMgZdcNapBtXnp
 rizMMMrWf.hxr7E3hoo56BRC5uG5j9dPiIBaw1qtkZTJ7s51TGNnCNqlPHimuEudqn68jfh1iWB.
 50A7JZZMOTOmJfhEFwZrxy1HMh_ndipVnccJmdbtU6jnP0kcHChx4XV4KysSRHp_AF.tp.tPW6bQ
 R0oqUTrOOkRpDM7bz3V6k7bU92FRsXN0MfFng0uYeRzBV3h.yuZ7JzJGKnll6lfKeddG12rrV
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: abc5a0e0-0eb8-48e8-9aa7-2fcc8b31d2c5
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Oct 2025 20:47:57 +0000
Received: by hermes--production-ir2-8c47c9895-2vz9t (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 84912c68f53f1cdff871eaed64ba6e5b;
          Tue, 28 Oct 2025 20:27:39 +0000 (UTC)
Message-ID: <cba49bd9-5172-4960-a2ec-6bfd9078d4be@yahoo.com>
Date: Tue, 28 Oct 2025 21:27:37 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kernelshark: fix bug in the behavior of ksglwidget rubber
 band
Content-Language: en-US
To: Yordan Karadzhov <y.karadz@gmail.com>
References: <5c7a78ce-b1f6-4396-982a-8b884242d8cc.ref@yahoo.com>
 <5c7a78ce-b1f6-4396-982a-8b884242d8cc@yahoo.com>
 <f6ec9f89-a161-e596-79bb-ec21aaa1047c@gmail.com>
From: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
Cc: linux-trace-devel@vger.kernel.org
In-Reply-To: <f6ec9f89-a161-e596-79bb-ec21aaa1047c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.24652 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Hi Yordan,

I tend to favor debuggability, expressiveness and readability in my coding, even if it makes for longer code
or seemingly unnecessary code constructs. I'll leave it to the compiler to optimize variable usage, I wanna
make it easy (for me or others) to set a breakpoint or understand what the code is doing.

On 27/10/2025 21:51, Yordan Karadzhov wrote:
> Hi Mircea,
> 
> Looks like this is indeed a bug, however it is hard to reproduce. I had to do a lot of right mouse button clicks before seeing this misbehavior to show up.
> 
> I will take the fix, but the patch itself heeds some additional work. See my comments in code below.
> 
> On 10/20/25 22:00, Mircea Cirjaliu wrote:
>> Accidentally pressing right mouse button while dragging
>> the range will cause the rubber band to behave abnormally.
>> Improved the logic behind range dragging to account for this case.
>> The state of the rubber band will be reset on right click.
>>
>> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
>> ---
>>   src/KsGLWidget.cpp | 40 +++++++++++++++++++++++++++-------------
>>   src/KsGLWidget.hpp |  2 ++
>>   2 files changed, 29 insertions(+), 13 deletions(-)
>>
>> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
>> index 7f2001c..a2c1fc8 100644
>> --- a/src/KsGLWidget.cpp
>> +++ b/src/KsGLWidget.cpp
>> @@ -190,6 +190,9 @@ void KsGLWidget::mousePressEvent(QMouseEvent *event)
>>       if (event->button() == Qt::LeftButton) {
>>           _posMousePress = _posInRange(event->pos().x());
>>           _rangeBoundInit(_posMousePress);
>> +    } else if (event->button() == Qt::RightButton) {
>> +        if (_rubberBand.isVisible())
>> +            _rangeBoundCancel();
>>       }
>>   }
>>   @@ -262,8 +265,10 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
>>       if (isEmpty())
>>           return;
>>   -    if (_rubberBand.isVisible())
>> -        _rangeBoundStretched(_posInRange(event->pos().x()));
>> +    if (_rubberBand.isVisible()) {
>> +        size_t posMouseRel = _posInRange(event->pos().x());
>> +        _rangeBoundStretched(posMouseRel);
>> +    }
> 
> I don't see the point in this change.

I needed a breakpoint there.

> 
>>         bin = event->pos().x() - _bin0Offset();
>>       getPlotInfo(event->pos(), &sd, &cpu, &pid);
>> @@ -291,17 +296,20 @@ void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
>>           return;
>>   
> 
> No need to pile if on top of another if here. Just start the function with
> 
>     if (isEmpty() || !_rubberBand.isVisible())
>         return;
> 
> The rest may stay unchanged.

Agree with you here, will fix.

> 
>>       if (event->button() == Qt::LeftButton) {
>> -        size_t posMouseRel = _posInRange(event->pos().x());
>> -        int min, max;
>> -        if (_posMousePress < posMouseRel) {
>> -            min = _posMousePress - _bin0Offset();
>> -            max = posMouseRel - _bin0Offset();
>> -        } else {
>> -            max = _posMousePress - _bin0Offset();
>> -            min = posMouseRel - _bin0Offset();
>> -        }
>> +        if (_rubberBand.isVisible()) {
>> +            size_t posMouseRel = _posInRange(event->pos().x());
>> +
>> +            int min, max;
>> +            if (_posMousePress < posMouseRel) {
>> +                min = _posMousePress - _bin0Offset();
>> +                max = posMouseRel - _bin0Offset();
>> +            } else {
>> +                max = _posMousePress - _bin0Offset();
>> +                min = posMouseRel - _bin0Offset();
>> +            }
>>   -        _rangeChanged(min, max);
>> +            _rangeChanged(min, max);
>> +        }
>>       }
>>   }
>>   @@ -1132,7 +1140,7 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
>>       /* The rubber band is no longer needed. Make it invisible. */
>>       _rubberBand.hide();
>>   -    if ( (binMax - binMin) < 4) {
>> +    if ((binMax - binMin) < 4) {
>>           /* Most likely this is an accidental click. Do nothing. */
>>           return;
>>       }
>> @@ -1182,6 +1190,12 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
>>       }
>>   }
>>   +void KsGLWidget::_rangeBoundCancel()
>> +{
>> +    /* The rubber band is no longer needed. Make it invisible. */
>> +    _rubberBand.hide();
>> +}
>> +
> What is the point in defining a function that does nothing but calling another function.

Layering functionality, i.e. mouse events call _rangeBoundXXX() functions, which instead act on _rubberBand.
For improved code readability, also having a properly named logical entry point aids in debugging.

> 
> Thanks,
> Yordan
> 
>>   int KsGLWidget::_posInRange(int x)
>>   {
>>       int posX;
>> diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
>> index cafc70b..8fcac55 100644
>> --- a/src/KsGLWidget.hpp
>> +++ b/src/KsGLWidget.hpp
>> @@ -315,6 +315,8 @@ private:
>>         void _rangeChanged(int binMin, int binMax);
>>   +    void _rangeBoundCancel();
>> +
>>       bool _findAndSelect(QMouseEvent *event);
>>         bool _find(int bin, int sd, int cpu, int pid,

Best,
Mircea
