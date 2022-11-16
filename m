Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC09CC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Nov 2022 11:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiKPLrB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 06:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239056AbiKPLqJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 06:46:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C064FF97
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 03:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668598161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vx4EoIkd82lFQIsqAndGe+rJOH7WCAg0BNnpMd7rtoo=;
        b=M3khGk41oiVot4BGSjtA/k5lM+snc+Jzz5WsbR0BZH6F/RTeRNsQY1bLx9il27KmH0cF93
        6/pd/KnBT0VuCrmyPG2u0l+vbd0RgbxLjl6W45YM2kU9Nj250b+gvVEMXOKBsR6VX2KHnJ
        pukYIpCaAH6P5Y6CfBCHWUOEJfja3Es=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-JBWkA5tvPQm1a0it5ZfgwA-1; Wed, 16 Nov 2022 06:29:19 -0500
X-MC-Unique: JBWkA5tvPQm1a0it5ZfgwA-1
Received: by mail-qt1-f197.google.com with SMTP id g3-20020ac84b63000000b003a529c62a92so12792997qts.23
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 03:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx4EoIkd82lFQIsqAndGe+rJOH7WCAg0BNnpMd7rtoo=;
        b=j7MrAy+lsbhIUxR/VGq0kdN8ltaWKl/i7W+oqpouOBpBRZn0jVGFLyAZTCVCYUh8yp
         nbTABydEqWD8EfFEeQ/kveOV+I9dMbmZrdltBIIGXQuSCemwOI4jb4JKbOrofRtiISL4
         ZQa5h23+m9uT4pefOG0ND2gkm3g2uupRWwyjfrTwZKRFAw6jGgxFVdVPqReszhS2adtL
         tc+yirQSi+zf2Eo+99Tsur1gzYumiw46VrUPkTMsIOr6+3+6RT5rnD8o8p90ERyLxU3D
         EC97DC0WlpSlEbkao0cRLvj+jIanE+VHpc/vUPRUPG1xP11+wFVWpZBhJ7Ym0/iO0uiB
         N8SA==
X-Gm-Message-State: ANoB5pnW/77LcRiccrBXyNaWGMPh1nar7t66LzB4VvLAi5OZJ9q94w4v
        JXm6u8XwtcNZuHnnA/DatsnxhWyYQfytlX/APVKp/xxebWGjeGzbeJF3YFkunDOB3FbTUfkWN8x
        kpjqWx5d7W/yu9t/dccBYQrIumcPfsgA=
X-Received: by 2002:ae9:eb8c:0:b0:6f6:59fd:3cd1 with SMTP id b134-20020ae9eb8c000000b006f659fd3cd1mr19031117qkg.96.1668598159320;
        Wed, 16 Nov 2022 03:29:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6crYzPE8E206nYYNeJ1/8RUvx032yFdrtt/G2QIy/2EhP54ATUHyLnqe8oTkxvjDj0nSabmw==
X-Received: by 2002:ae9:eb8c:0:b0:6f6:59fd:3cd1 with SMTP id b134-20020ae9eb8c000000b006f659fd3cd1mr19031112qkg.96.1668598159141;
        Wed, 16 Nov 2022 03:29:19 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id bs40-20020a05620a472800b006bbc3724affsm9985234qkb.45.2022.11.16.03.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 03:29:18 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH 1/2] libtraceevent: Add boiler-plate code for cpumask types
In-Reply-To: <20221115161005.74f62903@gandalf.local.home>
References: <20221018151630.1513535-1-vschneid@redhat.com>
 <20221018151630.1513535-2-vschneid@redhat.com>
 <20221109190634.1fd9200d@rorschach.local.home>
 <xhsmhedu9zc3g.mognet@vschneid.remote.csb>
 <20221115161005.74f62903@gandalf.local.home>
Date:   Wed, 16 Nov 2022 11:29:15 +0000
Message-ID: <xhsmh35ajyw6s.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 15/11/22 16:10, Steven Rostedt wrote:
> On Fri, 11 Nov 2022 16:32:03 +0000
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> On 09/11/22 19:06, Steven Rostedt wrote:
>> > On Tue, 18 Oct 2022 16:16:29 +0100
>> > Valentin Schneider <vschneid@redhat.com> wrote:
>> >
>> >> @@ -3484,6 +3498,11 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
>> >>              free_token(token);
>> >>              return process_bitmask(event, arg, tok);
>> >>      }
>> >> +	if (strcmp(token, "__get_cpumask") == 0 ||
>> >> +	    strcmp(token, "__get_cpumask") == 0) {
>> >
>> > Hmm, not sure what the difference between the above two are.
>> >
>>
>> One makes sense, the other doesn't :-)
>>
>> That's a copy/paste fail, the second one wants to be "__get_rel_cpumask"
>
> I was expecting a v2, should I wait?
>

Yeah it's on its way, I got distracted a bit, sorry!

> -- Steve

