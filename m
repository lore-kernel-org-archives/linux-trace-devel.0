Return-Path: <SRS0=uWkg=VB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E05C06516
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jul 2019 09:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 128DC218A6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jul 2019 09:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="If8K0jWC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGDJD4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 05:03:56 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:43500 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfGDJD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 05:03:56 -0400
Received: by mail-wr1-f50.google.com with SMTP id p13so5727045wru.10;
        Thu, 04 Jul 2019 02:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tCk/pg2eCfIzWunVIZ/esQp3AcyOQV8Mpx8u/265ads=;
        b=If8K0jWCCOog0NL7dj0U2K81gub9HQEqqNlDuwroHi0MLBSUa88oqmFuW7ekZl/LPO
         LDi67LpDixgX94uBjFokEr9bWEYm5nkRAsjOIFwfgz9Q1xAoZ1YpgdNrqBGGNj0qUUoD
         ub84/QxG9WCKdTGg0/i7QG+m2Fu/fnw99QMOl4La7CodBYHjzebTfh4WilpzT1O5PH6v
         aJJa3//5UPsaVQskl/hdmEPlrhPOvsCGbStLBnEsZDr/vTifDd91oe6mhleVYb9oLOjn
         7S/Fetwb3PGBvE2+fR+pF8R7ZjHIlIkDJSF8T6p9tEZGergV/WAoUmItZf4FxIAmfMGr
         XQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tCk/pg2eCfIzWunVIZ/esQp3AcyOQV8Mpx8u/265ads=;
        b=H49IoS8PrSOQK6KSTsmppuu2/APyEn5DwKk4Nkfck1ZaHZPjxjx5HnZ0xQ6cFTdwXn
         ZPsgk/0vneU07zv2wTFU+LriyOeC+rRADmEv1wDnnk0U7GZco7KfoKlAgyKMN1z9wY2q
         sdVJoVy0WstUtQVVurFZIOjhfIgc94m/tll9uLcvcjNqtyaclSI0imwsafaDczI50der
         jxhq4S+MLjGZwcGUFytY9//u4EpNv7QYFGaYk99fXcw1lmUeGyCdbCLI0kvGpJV0Xucd
         gC0K/U8q5MOqlSmfUtDJ5GCADzS0ZlWomTy/aKdacg/ly4cgTh5AY1yNokWsFAGuG9/l
         VjGg==
X-Gm-Message-State: APjAAAV97afJSdmzbX8uGMFgv3BrZVK5wUl8SW0jxjze2ZfAgzbMoyde
        5HrCx3QwWvShLaKTzzST0PgKgNllf4aKbdgKHKTll6Dn
X-Google-Smtp-Source: APXvYqxcQGXFNbzQP8f+hNbAbTPrxYenkpxyqRvjC3U6dV9iN+nh3OHp4xuTx+fQIdhFSz/HGDkjNw5IIGr52mGq4ek=
X-Received: by 2002:adf:ec0c:: with SMTP id x12mr32924132wrn.342.1562231034341;
 Thu, 04 Jul 2019 02:03:54 -0700 (PDT)
MIME-Version: 1.0
From:   Naruto Nguyen <narutonguyen2018@gmail.com>
Date:   Thu, 4 Jul 2019 16:03:42 +0700
Message-ID: <CANpxKHEVmPzxU5SwQV9Ka9z5f-8EYqS=eoD0XEqMkUVQ9tiTbw@mail.gmail.com>
Subject: register_jprobe always fails with -22
To:     linux-trace-devel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi everyone,

I tried to write a sample jprobe as the link
https://bugzilla.redhat.com/show_bug.cgi?id=1275809 (the sample is
attached in the link). However the function register_jprobes always
return -22 or -2. Could you please let me know what these errors means
and how to fix it?

Thanks,
Brs,
Naruto
