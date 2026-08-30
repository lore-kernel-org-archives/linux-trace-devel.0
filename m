Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D33261B8A
	for <linux-trace-devel@vger.kernel.org>; Sun, 30 Aug 2026 02:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788055220; cv=none; b=SEMdIuQ8zOQ6BEpSYRd8DJb3DWBPET9CFjPoBbhL8JNMBQUNfz0d8gARWMiBWRo74Ql78BrmOdJKPatRSad5F0TCEElvHayeZRW9ChLhqXudrFZ+aha2Wp4+wEFrGxl4piNoaLGo0enZQPjHD6NzANSLs5E2ninSEwebfyBjaek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788055220; c=relaxed/simple;
	bh=De94HUVlj3mys9Tww3/3BolvlAFRbkqAshXuydFnX2I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ujNEvFu5TgoVz5HumoGg2wAPVS1KY9m16CQd8VWX7tPEcOd/7bOD6w1pyKmxXgS2pOBn/cJLOCVhk4/+7x1tNfGU6nqjOvcg16K6qbPetaIPAc3wkgMheMbK70EMknHaaGgVttxpmEWpabrAJ8YyQmbjLo2SKNV8ubJTnvLBUu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dwN0+FO1; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dwN0+FO1"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbedf433a99so2525571a12.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 29 Aug 2026 19:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788055218; x=1788660018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q60rYj+Dq6ewavH4MQemzA0mqgbqh/EDcxUf/sL20Tg=;
        b=dwN0+FO1ZqDbN807Eu8H5ZW3dVF3vKN4QH+iiBO4LdTLYHjUpbXUH+7HY5qixbXZK/
         HATh3xaz7VWfm9V5U2xMx14yLOnTcjwpG2ftyrUrmWOlHX9GUYaw8ERwO2x2sWYrUt2h
         UE9j0CtgHcks7xbq4JTzNzKV3ff8jVp6eFTflYX/VrB+mfxLRDLpC+8sYLwa/mG0hZaM
         gF0fFg62iBmdMXM/0MwnBxR7xpfHhpSUTgH9fd2deti8cv+D9IcOzsN3E8Jac8I9qP1O
         P3EYsMOfpDNhSg5ExtoaIEPpQ7Y4razWS1EnJiGwW9PiLZI/5xY8MBk7ypiKp30MWNNJ
         rddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788055218; x=1788660018;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q60rYj+Dq6ewavH4MQemzA0mqgbqh/EDcxUf/sL20Tg=;
        b=iz88oxq4al6CHGIVJbKTII47jsiftSihlpN14yVQd158s/osBHvcxHSm6zisg9zH7T
         dw33CmsPwtLaSO9j0c3EJG6lBc2rsWjCvnKb7C5F4vbmuzhYFCW1gV2eviUJEHNOsjkt
         y3RVYUuPaURBfIxDU3wZ9LfdYUiMP9FpVnwzrEUP0ntep2V8UpyrutCCrLaQ9FYBnwbw
         5gnHWIKnStGaUbNmkHWofjpqGxDNIbVc93Xd3xdsV/ROm0a62AE//qtmWmqMxmV3YWn/
         sb7KHcDeJM95gvpXks7jWFQTB7tfMoAKn3+txcwBUbXObQladr36L4lGBcFZSHkJS3bo
         aNkA==
X-Forwarded-Encrypted: i=1; AHgh+RpkB9lG+VqNdJBQGuGYLx1OQYyeGTz+qdWRvLr03rDK0HOrIuoltKlPKngBe+EhCxvJD6FYYtHD/PABnmaplsz94A==@vger.kernel.org
X-Gm-Message-State: AFuF++nSZ/KEwfmWtPlkpf8srcp0oCigmTrb3GGojRBlfAiZmfegkJJ9
	9OvTiqFKnTDdLa+o5UxB84vQHu2QWrxTuvifgSQHFGGVfiqDX9fwhyy5K7/VeA==
X-Gm-Gg: AR+sD13XGYEJ7MRe8nt9l/rO6feXPYjKsjzYP8x1wxFIGCKXP8oS8C2jls7TiNFeg2K
	7lz+A1FhUwyU9x2c4OArn+Uoi024WUJ/JZsVJEYVFy+cvNjxtt7q7QAdk2uZki39pwiyV6yCOSC
	O1zuZfy6OlctcTsqTbMs9sD+KAKpnnoG+3gy0ES2JwDiXTte9gxVu9CYbfJ6Av6090Fi7pLArF/
	MeFkrdOXiw3NXVeTivD7mO9cpUnViERQW6/WBtxOR0CWGlPZ1ofr07siVCWP8rGFW1k7Nz2pzvZ
	7ZrpRHnAia26PoXE03oVZkm701j6WAWL6r3jaUEwbbuVGyC4cjifThDrgCma6+O+l2cgUfaHnDb
	dJEqrrJ4zfIOUMDdVUyeqHdeA1OUtQghFsuJSogMCvKqFciEWHeWn7tJuWN1JEYG7BLs/mB3JEO
	Ml7VLPXbYepmHg/ne4RtUzM9ht6iHrZAA=
X-Received: by 2002:a05:6a21:6e97:b0:3cc:3d08:da39 with SMTP id adf61e73a8af0-3d26246fa2dmr31868664637.0.1788055218470;
        Sat, 29 Aug 2026 19:00:18 -0700 (PDT)
Received: from z2 ([2601:647:4401:2cb0::3152])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f784857sm19367213eec.3.2026.08.29.19.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 19:00:17 -0700 (PDT)
From: Namhyung Kim <namhyung@gmail.com>
To: uftrace@googlegroups.com,
	linux-trace-devel@vger.kernel.org
Subject: [ANNOUNCE] uftrace v0.20 is released
Date: Sat, 29 Aug 2026 19:00:07 -0700
Message-ID: <20260830020008.157705-1-namhyung@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I'm excited to announce that uftrace v0.20 is just released!
This version comes with a lot of new features and bug fixes.
You can get it from the below link:

https://github.com/namhyung/uftrace/releases/tag/v0.20

Now uftrace replay supports 'callsite' trigger action to display
source location of the caller of the current function.  This can be
useful when there are many calls to the same function in a single
function.

    $ uftrace -T getpid@callsite  tests/t-abc
    # DURATION     TID      FUNCTION
       0.558 us [  19501] | __monstartup();
       0.281 us [  19501] | __cxa_atexit();
                [  19501] | main() {
                [  19501] |   a() {
                [  19501] |     b() {
                [  19501] |       c() {
       0.596 us [  19501] |         getpid(); /* from tests/s-abc.c:23 */
       1.083 us [  19501] |       } /* c */
       1.279 us [  19501] |     } /* b */
       1.403 us [  19501] |   } /* a */
       1.583 us [  19501] | } /* main */

And there are new output fields for uftrace report.  They will help to
find important information about the execution.

 * total-max-ts: Timestamp of function entry with maximum total time
 * total-min-ts: Timestamp of function entry with minimum total time
 * self-max-ts: Timestamp of function entry with maximum self time
 * self-min-ts: Timestamp of function entry with minimum self time
 * cpu-count: Number of CPUs that function ran on
 * cpu-list: List of CPUs that function ran on
 * cpu-mask: Bitmask of CPUs that function ran on

Also uftrace dump adds --format option to specify output instead of
the dedicated options like --chrome or --flame-graph.  These options
was deprecated and will be removed in later version.  So please use
uftrace dump --format=chrome instead.

 * available formats: chrome, flame-graph, graphviz, mermaid

In addition, a couple of new scripts were added to generate data in
other formats like:

 * new script: dump-perfetto.py, dump-firefox.py

Other notable changes are improved dynamic tracing on RISC-V, Rust v0
demangler support, uftrace info --system option, Fedora minidebug
format support and command-aware help message.

And there are more bug fixes and improvements.  Thank you all for
making uftrace more useful, efficient and portable!

Namhyung
