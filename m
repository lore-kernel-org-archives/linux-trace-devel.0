Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826D9249E5
	for <linux-trace-devel@vger.kernel.org>; Sun,  6 Jul 2025 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751782980; cv=none; b=N3te3zsZykllLFvDXzdTs3/x3h4gbUUgBR7THDvDOEUuFq/yaIzum9E1GUA1qehnhinzhm6EUrVa2vp/BekNAkqX3TRoMBHoBKWKb/njwgtBsOVRBBatm3rjb0E0fZ2qgO7e4bQXJkD/gkqmxUxDYNd59Wg0bufOIA8rVxQOJ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751782980; c=relaxed/simple;
	bh=ueSoAZYxY8gj+BxmxVW3wYH6inTXzI/PiCH19eyUj/Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=evJV162jXhGP7JSR2Eu54Awd3SqzJzqZQ6M+wCQ3qdOunr6fVt1Mrt3otic0o0dmgiSsikiiFYdk2dqZ7Cpjkamt6+vO/MoP0yBnFhGZ1F1EDRmAmKom1THJKQ6E4FoXLy+lyNTpOhiknx3ezSlz0UBc5OSGE9iKJHc98IaCigo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2BW4L8J; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2BW4L8J"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3141b84bf65so2094652a91.1
        for <linux-trace-devel@vger.kernel.org>; Sat, 05 Jul 2025 23:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751782979; x=1752387779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=JvQDmlxrXGpa8uSPE5vDAfwZ/7ZhJmy5QPRXsSaI2iM=;
        b=P2BW4L8J8wXhO+GsQvTN51rjO1klsIoBQqoBflLgbLcGv9JBj3nb2NJl7GO3dtyolk
         HfSJwbZQjNTthvR6f4I0hAK8h/1wcdHjjaeUMJXqi61ANZKN5Ps7OL0xngkrI50mu3Vt
         DfPT4fcbnut2eSnLE+0snlos7EhSwi0zkwKz4FMfQea7ZlSYGmgn1nF0rixyId7/R47O
         ULx+vgvD7Eg07/rZRFSxA+qdlNC22TVyYKXe3KVK+PDpcOepB6IM5dOH0wNQ1QHWVt0f
         61Ae5Y5ZjNLdy0ftdR68Rvs88QU4p/Zc1YaZ4yoOnk8CFuYAc3sXBRuzQZIp/PBzXVBt
         EbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751782979; x=1752387779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvQDmlxrXGpa8uSPE5vDAfwZ/7ZhJmy5QPRXsSaI2iM=;
        b=j22bVEnYay9n3FoLCbU8RtnyAdZIbzPO/ojJ4Z9TA+YA58j0lJ0q10501SyaRgwFAC
         q+cbOmChPNQxj+wH6eF/mSoA1AZsfNv2PZX3urq8h6Xx4WaQJLAx+BnQM2oqH3Fn+bYS
         l4lNElPJ+8Joz8kRhtGqonujpdpN/sGrSaQnUtfuQ2oghHI+YcUhDltuMumq0NG7+21N
         UlP95a0rC5FywFjT+pB4h6X7uGd59NK54o61P7+riA2LHmlfMosmNxpVLbeq7qvLOmJM
         WMCB6zga3NcjvMBlNMMSuHZDm36v9jKUyHA4iioLzbqcavUbcBDGeGqVW8CFAnajjLat
         dqEw==
X-Forwarded-Encrypted: i=1; AJvYcCWSM24xh9o9YudytntuiyIjo59eNCwc9Gcg/tno8wBlIpZe4aUHUaSVsJ/27AVOfGX7a8JzqBdQD0s2hi7ANrvhWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTDIOfEHLpspldhnW26Hcdla9pDmvZ0LZfwphRZ99Mjvtoj5Yx
	eDTyyyO8YK+2MepWANdSO75Kny0ciHh7DPxDy2GPGwAG63Tn8eqglmJh
X-Gm-Gg: ASbGnctkxspQ7LgC7EcXDzqUwa83vOwNaBikarNSUT95lfHWQiqu+scJT9699VgfkiM
	3UkG+QGb8g8tC6A1yBAwQ8HV51Ftk73US2motFfblQR4KZdTyMw55/7XWX+EsDhDVPhOwyTrxd+
	BClhHoMRd3bMm8n44HKD7Pr8ehLZkiSFMz2naFy/AmdeQIOR6OORHxjMQzXlldjeiqjio+RbqcU
	tflH9FtRTljf9eYtDlSdcpbhS+5afg0PbHOLsE4+qi2n7JWXjN3RXCU2iHmY2m5tJ5AANJKT9Db
	0gauiZXdrz6IU4UHplEaINSa7bbgKHfz
X-Google-Smtp-Source: AGHT+IFSQkAZpEMsansugBAkYDB1cB3+Tl92x00iLeso6/w0Ge+lnojxgw85IniSVvJZRH1YZIVt0w==
X-Received: by 2002:a17:90b:54cb:b0:312:db8:dbdc with SMTP id 98e67ed59e1d1-31aba8be97cmr6330836a91.20.1751782978638;
        Sat, 05 Jul 2025 23:22:58 -0700 (PDT)
Received: from z2 ([2601:647:4401:2cb0::518a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455d24esm57571345ad.112.2025.07.05.23.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 23:22:58 -0700 (PDT)
From: Namhyung Kim <namhyung@gmail.com>
To: uftrace@googlegroups.com,
	linux-trace-devel@vger.kernel.org
Subject: [ANNOUNCE] uftrace v0.18 is released
Date: Sat,  5 Jul 2025 23:22:52 -0700
Message-ID: <20250706062252.7110-1-namhyung@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I'm excited to announce that uftrace v0.18 is just released!
This release comes with many bug fixes/updates and some new features.
You can get it from the below link:

https://github.com/namhyung/uftrace/releases/tag/v0.18

The main change in this version is filter condition support which controls
filter behaviors based on the value of an argument.  You can specify the
function and argument with C-style "if" condition.

For example, say you have a program that calculates the fibonacci number.
It'll call the 'fib' function multiple times with different .  You may want
to trace it (and its children) only when the first argument is 2.

    $ uftrace -a -F fib@if:arg1==2  progs/fibonacci
    # DURATION     TID      FUNCTION
                [   5446] | fib(2) {
       0.169 us [   5446] |   fib(1) = 1;
       0.056 us [   5446] |   fib(0) = 1;
       1.524 us [   5446] | } = 2; /* fib */
                [   5446] | fib(2) {
       0.056 us [   5446] |   fib(1) = 1;
       0.053 us [   5446] |   fib(0) = 1;
       0.452 us [   5446] | } = 2; /* fib */
                [   5446] | fib(2) {
       0.079 us [   5446] |   fib(1) = 1;
       0.053 us [   5446] |   fib(0) = 1;
       0.447 us [   5446] | } = 2; /* fib */

You can see `-F` (inclusive function filter) was applied to 'fib' with
condition that value of the first argument is equal to 2.  Of course,
other comparison operators can be used.  But the condition only works
for function name filters like `-F` and `-N`, and only handles integer
arguments as of now.  If the condition is not true, it'll ignore the
filter as if it was not there.

The `-a` option is used just for illustration purpose and it works
even if it doesn't save the arguments.

The next new feature is max/min/avg fields in the graph command.
Like in the report command, users can use `-f`/`--output-fields` option
to specify various fields for total and self times.  This also works in
TUI.

    $ uftrace record  progs/fibonacci
    
    $ uftrace graph -f total-avg,total-max
    # Function Call Graph for 'fibonacci' (session: 9dba9c6c4a0c958f)
    ========== FUNCTION CALL GRAPH ==========
    #  TOTAL AVG   TOTAL MAX   FUNCTION
        7.851 us    7.851 us : (1) fibonacci
        1.404 us    1.404 us :  +-(1) __monstartup
                             :  | 
        0.889 us    0.889 us :  +-(1) __cxa_atexit
                             :  | 
        5.558 us    5.558 us :  +-(1) main
        5.134 us    5.134 us :    (1) fib
        2.301 us    3.396 us :    (2) fib
        0.953 us    2.197 us :    (4) fib
        0.346 us    1.457 us :    (6) fib
        0.162 us    0.199 us :    (2) fib

Also it nows support LTO (Link-Time Optimization) build.  You can
override AR variable during `configure` if needed.

    $ ./configure CFLAGS=-flto AR=gcc-ar

And there are many bug fixes and improvements.  Thank you all for
making uftrace more useful, efficient and portable!

Namhyung
