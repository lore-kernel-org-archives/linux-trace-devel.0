Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11024C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Mar 2022 11:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiCVLz0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiCVLzZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 07:55:25 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D470F23BE0
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Mar 2022 04:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1647950036;
        bh=35jTwyRPrqSpoX3MJ/oTE+cyl++7Wjspq8ZUYKpR0l0=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=KCJE5WzUVQxeO8fYeDp8yNMSyLXJWzO8IkxheEmZAYJZIXpowq6HuKf3iEdwxzWEe
         rx0gfA4HnbyiZC2oABUpyHi5Ef+shBFBctDMfZ8vB79wXx/LYnBLi7zOpTUEjW+Bem
         dlo2fWl0/d5x6qdyPuNM2GjRoYqqMd51ProfXWBQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.56] ([37.4.228.18]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M9Wyy-1nTJh93NeW-005Vii for
 <linux-trace-devel@vger.kernel.org>; Tue, 22 Mar 2022 12:53:55 +0100
Message-ID: <4ea9e4a6-c15f-5c5c-a36e-2ed80c1ee0da@gmx.de>
Date:   Tue, 22 Mar 2022 12:53:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] kernelshark: Set QApplication::desktopFileName
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org
References: <20220321225330.825082-1-nicolas.fella@gmx.de>
 <113dd55a-1324-c3a7-7663-2e206e069a38@gmail.com>
From:   Nicolas Fella <nicolas.fella@gmx.de>
In-Reply-To: <113dd55a-1324-c3a7-7663-2e206e069a38@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eP9u67uzvXPXntUY7R1WAFhrvgRys6Q2JgP80BtjHf2FfFpb8Zt
 tjDJmjLd1GIZZnpETgFPWOnfiMhHq6+aranHtxwwZTX6U2KwEfLzlErKgJZizfsX8aWEKgI
 A/3kdHUifDCRvp0Yo8sXXtBr9zB+EdL3FuchQu9fP4/tEIIJZO8ls+FzZSshwnHDDfxIq19
 3emiy0WAR9Im22J1ET1Iw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7PaiCIHk/xQ=:Zq8lt4XwJZCp1ZKet0OpHW
 bl5H8jIM3CMw4S/5ooqNbSGVjw3o/YXxWZYvcZexY84btb5zasHX6ELjNLDxjJ2hZutkoVaFG
 8c6euMtpJ8Geb5qHA5WlgFbMa1vw77dX5Bn04BGfj79NbyHWHMCWy++zns10B0ZXmsGsYmwl9
 4SVuM4grG1CIDhelMUnX58FiKost9CJ+PFgdg2BRq/hX6rUBSTOvF5DreVpYfI9Dbs0Q1mMIA
 AowCkZxWhVnUT8s6YVPfPMtcFVqcxBQosB8vUurcyVAdL05Rs6dpWRjxziH3Z8d7gSjsRE5ef
 E5R+g28iW4l+1Sa9tw8UtgsnoKBsaOrV0Zt3OgXJbrX2qUIbUkLFJoQ0f8FGzt3EqveH8BSSW
 pYRNr/NkPo0V67X5TvZUIAoQHoyWQGJGVNM8uJMXn38pnBxBfZk1dfVWQP7TZKK1ClyBkyh2a
 S5krTTB2oDD4L2TOp0XVkjH4ZV/403EB6PQgWN7/catkvUAnk5UMSFm/uccoq87KjtZZIwXLO
 c5FjuBH5kNab6FitpQYiGC76PdlFzrUezPnURIexXH+jM6lJdh8ozjH3LApW2Mf+jZWXRSf51
 dFVSuYfevjkw9ohnEh4aC3ETBYWXNRkezchJAi4Dw8aI6p+msX6W8h1iV/iv8CQUs8rBkt916
 NWFUjRgVUHgKRByCmKjHcjx71h0c9sZwj/+x0fmT3vy3qhfzLSaIjIN3Sjr0R44OMNTwrYcP3
 mj12Zc66D9b2XMGw5hpse49mdCCX5ADfpOYZjhe246Hwgp/Wp1MazV2SGM4NHAgcNdzFG6a9a
 jXbPFjOK/wsvDVsgH7m7ggvL/9jgk0yusD5fgtJPa/FAtLN4lsMIUELpSjlfYOGzvaFsvHOHN
 2Ymm3f3fALilvyCbKUXaAHXC9VaMGgGe2OmLwHZlXhXOcSmMayghLU+AVQgrFJvALyzamVxe/
 huezxbhkvDuQ8xDNlpPf3Ztxz+8o+fR11lCfP6pZunHdbg8flmJWJe/0yOuJXD9FJiZD9N2vG
 rS3nga/yP/rYj/1yBk8mZrPCJijuLV7UgOVdMPV/0ur2bVI+xuh9Xi7V/Nr5wogYY0GnZa1eY
 tizsgL515TOpkE=
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 3/22/22 12:32, Yordan Karadzhov wrote:
>
>
> On 22.03.22 =D0=B3. 0:53 =D1=87., Nicolas Fella wrote:
>> This is needed for properly associating the window with the desktop
>> file.
>>
>> This is needed for e.g. showing the correct icon in desktop
>> environments.
>>
>> Signed-off-by: Nicolas Fella <nicolas.fella@gmx.de>
>> ---
>> =C2=A0 src/kernelshark.cpp | 1 +
>> =C2=A0 1 file changed, 1 insertion(+)
>>
>> diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
>> index 92bc1f1..c373f54 100644
>> --- a/src/kernelshark.cpp
>> +++ b/src/kernelshark.cpp
>> @@ -56,6 +56,7 @@ int main(int argc, char **argv)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int c;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 QApplication::setAttribute(Qt::AA_Enable=
HighDpiScaling);
>> +=C2=A0=C2=A0=C2=A0 QApplication::setDesktopFileName("kernelshark");
>
> Hi Nicolas,
>
> Looking into the Qt documentation, it seems to me that the argument
> must be the desktop file name without the full path. And the name of
> the file is 'kernelshark.desktop'.

Hi,

the .desktop extension is implicit/not needed here. The documentation
says "the _base_ name of the desktop entry for this application"
(emphasis is mine).

Cheers

Nicolas

>
> Thanks!
> Yordan
>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 QApplication a(argc, argv);
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KsMainWindow ks;
>> --
>> 2.35.1
>>
