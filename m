Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9E1A682C
	for <linux-trace-devel@vger.kernel.org>; Thu, 15 Oct 2026 04:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792037824; cv=none; b=G8dwEbIuJPMWsvBSrq8GyJFBFu8mrJzAqwnTIWf7xvBwDsmk4oAlFy3g+NepXbyGI/XIa7wK5iOsuoKZI0YLP6UflmAGxfTAkN4328LUKocp4IJ2LE73UloGE/GxxzuRwW69l4E59/8LlaICPHRnD1cY/hUOytuI6pmSUNWeJHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792037824; c=relaxed/simple;
	bh=d418s8KnFa1nkaQxe7NSyC21DVRT09XKPgr4UUbntoA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MoZjWYJm1KJW+4fjEspfze7JpidCMr0TqHc9WfaEYvuQ7CY2BcKqhkUouMcXx1IkwDIyU3h68uGFJbXwaQ8txXObl2/mW2iFgeisLFztjWPsEUEOo0i3/mY9HakcjCbyZgtAYtgzV5NJoCrgrH7N4jCVSYgM1NtXbuR2zzpW8QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHH/ckCA; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHH/ckCA"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-30b6dad2382so11272097eec.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Oct 2026 21:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792037820; x=1792642620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PQCbqmp9P4RNUvW0YIKd3fiEBVbC0Pk/gLQ3uLtjueg=;
        b=UHH/ckCAzXIsEVjXOFZ4etl5Knsv9KcH49pYWemMWLDbQn7EHqFrEBVozGlLqbj8o3
         NymbVHbbM7L8QhOwmH6hx+6tNeKFFlkWdZBfp7h+o60PfHqvBFRhIVYORwgGMiKQgpNa
         v4W8xbc6NMVQfrRrmVF+cWdnojBkQKEO/wt1FeT3LA8DUvZysX9bMgi5c2bs+eNtXdcZ
         91xQD5tkumHiHlBOKyYLeiqRd2fvNutGj4DNBjNu4J85BWLdO6zGHQCFtSRYgwSzDpr4
         N8+z730TtplEMdoV6FB0MjTwjjXSNRcaw4JD9NRpGkSaEmticw8+Y3eP5/jJeQmFBuFB
         SDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792037820; x=1792642620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PQCbqmp9P4RNUvW0YIKd3fiEBVbC0Pk/gLQ3uLtjueg=;
        b=Gwe1/cL+lOYrJNFHbq0oST3iJ/t5W2MzgieMef5GpMCbyhRP0f/s+IS6KA2XVBIRCu
         Nw8+9eo466UlPdYlUBKfPTjvA2xvDk9JnjTVqAJsIVgw2XnaGY73un640U8ZmYUII0v2
         CgTGoTf2eCEUAUiCypFQaMEo1ERYsVy7Hr0i0V2JwC8QTmCKr0CimmPprez/Ysg7QyQf
         leu6nRPShA02lvzkpNHhfaFFOkDAyqymnx18wsMEelS9YOizzEUcCIUdzL/TxhFm+70H
         BpuUB7djS3336IW/DtQig2x68AbCS1WYGnNIgJly0ao9PyVcaOXtHYoZxqamK5UUz0Ez
         ndZQ==
X-Gm-Message-State: AFq9FYLS99Ln1Xm1o+8478YdgwhU6gOqRMVbJX+s/q5WyCNHxGAR/jrC
	ytt9263wW+7JT4Op7C0waZ6ABZkP5X8yE2N+AF1i7gQyjQu1WOtuRcQT
X-Gm-Gg: AYBFou0hofYmC1s5x/c1BTzNOiVXK0n6CvjDaZ4MrG3RBVT1dIsl0yuZmNxwffTn5LW
	qIQCJ9a1PNmLNbT3anCDlt8NalNhRWXqNyEXUWXw0mHThjO9/VOV78BzIQPlmf6h/oSVlEM17PI
	+IFfdzX3bv0N2KqrDtDaUTlIJyI4G8ZkaFZQOw6O+qEK9Q/JptzZ1SSyJfU4pj0qSpFj9kiZw7j
	6DykjeaUx8h4PpHAXgrrxz6BhXpjgij7n4je4hqwcw2s6773vR7oP1IBgH8ARDESR6BvSvweioV
	T8O9/9XXKGIqeWYpnWRRAweQR3cTq62/GbziSk59ZG9iTuyKOMv22LoseeptPKrXLTRn9y5wlxv
	pLgfGMn3/a0qvUAhIs1Cq6hfv8ZwOPIjG5ShUV1NzUljPTLZwKj3glMAqLbfvGhJIAouIFioBAS
	0D2z5l7h+ZPjb96Xju013Xq6RGZJg+jYhMx2D9ivlcSEdiI9Z1eHC/oq8mGw7WkBTPTkhMs0FXW
	xRoL1ji4srINEcfVylV047sEszlVkMandWxnpnK
X-Received: by 2002:a05:701b:4349:b0:15c:20b8:796e with SMTP id a92af1059eb24-16a5f112b00mr25437685c88.22.1792037820215;
        Wed, 14 Oct 2026 21:17:00 -0700 (PDT)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:2ac1:5cc4:64e6:db5a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-16997c21ff3sm51405213c88.2.2026.10.14.21.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 21:16:59 -0700 (PDT)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	lipengfei28@xiaomi.com
Subject: [PATCH 0/1] trace-cmd: compress CPU data while recording
Date: Thu, 15 Oct 2026 12:16:44 +0800
Message-Id: <20261015041645.3725172-1-lipengfei28@xiaomi.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recording ftrace data for a long time produces very large per CPU
files.  trace-cmd keeps the raw ring buffer data on disk for the whole
run and only compresses it when the recording ends, so the temporary
space needed is the full uncompressed size of the trace.  On space
constrained targets, such as a phone, a recording of a few minutes is
already enough to fill the partition, and the recording either fails
or has to be kept short enough to miss the problem being chased.

Compressing the data as it is recorded removes that, as only the
compressed data is ever stored.  In our runs the temporary files are a
few times smaller, which is the difference between being able to leave
a trace running and not.

This adds "trace-cmd record --stream-compression".  The existing
compression of the finished file is untouched and remains the default.

Tested on arm64 Android with zlib and zstd, with the default sub
buffer size and with --subbuf-size, and the resulting files report
cleanly.

Li Pengfei (1):
  trace-cmd: add streaming CPU compression

 .../include/private/trace-cmd-private.h       |   7 +
 lib/trace-cmd/include/trace-cmd-local.h       |   3 +-
 lib/trace-cmd/trace-compress.c                |  67 +++++
 lib/trace-cmd/trace-output.c                  |  71 ++++-
 lib/trace-cmd/trace-recorder.c                | 281 +++++++++++++++++-
 tracecmd/trace-record.c                       |  76 ++++-
 tracecmd/trace-usage.c                        |   1 +
 7 files changed, 480 insertions(+), 26 deletions(-)


base-commit: f35c3b04f30c6368413ceede2a27a5dc90f3ea7c
-- 
2.34.1

