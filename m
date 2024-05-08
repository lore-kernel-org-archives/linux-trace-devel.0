Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA6312C497;
	Wed,  8 May 2024 21:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715203346; cv=none; b=Z5VxVwBXWAw0RFF6c4by1JYTVJCYzLGjeSo52s3oTs0FI+/f9h8l6a7lYuHAxioQ8Y04++g79YsvyPdL7XYVFFmEW2Clpm+epm4wAzQSAEvh6yk0ZW6fPP+hMC7i22SQjt8CPRXDpWEUK5dW6miIcj92Mtv8Yp9cv0lxkNu5y4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715203346; c=relaxed/simple;
	bh=e9USpes2DzX9zdYg/vrpyLlR/1aUhbsBA0KXXm0Gero=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K1D1/03jQCY0slE/7oeAqGgz2sco492NMPXW04llXDWk5f7YCpl0JrM8vqJOsbOIJ8vS1pp6Xrk2yJmZLlC6bSX2bEDufyqoUSLCWGibCeAjkdC8IhQaZUf0TzR49S50AEgJz+zAk28ajH8VvfLpWgQ2mwP1uEorcnkz2aO0pvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VnCDWlGr; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnCDWlGr"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-78f0e3b6feeso8183685a.1;
        Wed, 08 May 2024 14:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715203344; x=1715808144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=EF6kiOxUxjMHaMOZEZWN8I3r+QaY2TVkICy8VZIjNZc=;
        b=VnCDWlGrBWlFOoUoqn5GudK6RcqRzTy13jb82cKsQBLnQf6W3pkDjv6+Dmjygg7bbA
         gyID3qm6sBdn54Ju3055D0O+IxAcHyu2BQ+F+9WqRFxllaGl/tp4RSto8/aOEtvZay89
         eGtvtObVBToAiXLLCa8Su1pyotRX8DgrKJUth6Sk7uF+pQPWfUO30ZiTz8q68UKRp3hS
         PJnjia+baufbZrd1oCb+hJHmp0Bbv7QEJpYFNDjoGkbU+dWCuvdrAU7bFcb/xR01rFK7
         q/5mx+Sv0co+3l3kK3EKiGNB/SmJyHc8/e1WzlZejz8FYLHDAAe7JcLnxQ3Hwck8sm7q
         3IeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715203344; x=1715808144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EF6kiOxUxjMHaMOZEZWN8I3r+QaY2TVkICy8VZIjNZc=;
        b=YDIn63f6zbmwj7VOQCaf03Zfe5NXVBRLnjwJSRhOGzrsmK3VHp5UzYJE2KynBoKzeQ
         5tdoKvGKvVR87FY8rpW96ej7GuJfc2LtIv62PF2eVy9YKeQ9noG78prWpxPdcxfUlhw+
         PdNBAHvki6HkDtO6hqtXJsAlN5zHtrnxOd25Cw58t64TMZ7nGosiRAR2oEW2X3wTa43c
         BwVPwMWdxWn5DfbvDoxQN77ULtHh9x2iNz503obzh2o3CPSvTNdnXa5ij2lV/0LCHAKi
         p00lHZjSFQlaIw+uIPcq4HjuGwX+tqu4joYHRwbASMl5zvtt0IOtXBTKvYgfhjrlrDyS
         lVZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXb09koDBbSnXKoW58JAEb0gPT/RlUDSkVZpDf2+HiBSZBKlwiC/EKZdxKbA+tATbj3yO6awxSqVumrq6OB3dg3aX3RXSeCJzqWRhdDPovcqyOJvhdLgt3kq+PZTCKWKgrzvfUjnCxTJM4fk3cPiz4=
X-Gm-Message-State: AOJu0Yw6kzp5DZHM5rhOtkj78xbLiP7McE7xgJfQ8MYBD+uyVvjj3tJV
	leN84DVVOJkIm05KeTIbHKUX8/0FkY8Nobzp3qrMMclbpYDO/6Ym
X-Google-Smtp-Source: AGHT+IEkYkR/8Y3Nk2iLGt8MFsDJ4syw93kCnUnOc5c78ck1kRsRAQrpnX86L0tY1UlArCiHrMfztA==
X-Received: by 2002:a05:620a:5608:b0:790:c017:89e2 with SMTP id af79cd13be357-792b26ae15dmr475307685a.16.1715203344170;
        Wed, 08 May 2024 14:22:24 -0700 (PDT)
Received: from fionn.redhat.com ([74.12.5.183])
        by smtp.gmail.com with ESMTPSA id op3-20020a05620a534300b0079071ee067fsm6265258qkn.31.2024.05.08.14.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 14:22:23 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-trace-devel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH] rtla: Fix -t/--trace[=file]
Date: Wed,  8 May 2024 17:21:55 -0400
Message-ID: <20240508212155.71946-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally with a short option we don't provide an equals sign like this
-tfile.txt
-t file.txt

But we do provide an equals sign with the long option like this
--trace=file.txt

Also, a good parser should work with a space instead of an equals sign
--trace file.txt

Most of these are broken!

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
Saving trace to ile.txt
File name truncated

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
Saving trace to timerlat_trace.txt
Default file name used instead of the requested one.

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
Saving trace to file.txt
This works, but people normally don't use '=' with a short option

/rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
Saving trace to ile.txt
File name truncated

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
timerlat_trace.txt
Default file name used instead of the requested one.

After the fix

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
Saving trace to file.txt

I also tested -t and --trace without providing a file name both as the
last requested option and with a following long and short option

For example

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t -u
./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace -u
./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t
./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace

And all correctly do Saving trace to timerlat_trace.txt as expected

This fix is applied to both timerlat top and hist
and to osnoise top and hist

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/tracing/rtla/src/osnoise_hist.c  | 11 ++++++++---
 tools/tracing/rtla/src/osnoise_top.c   | 11 ++++++++---
 tools/tracing/rtla/src/timerlat_hist.c | 11 ++++++++---
 tools/tracing/rtla/src/timerlat_top.c  | 11 ++++++++---
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 01870d50942a..8ff1c816eb6a 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -640,9 +640,14 @@ static struct osnoise_hist_params
 			params->threshold = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg) {
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '0')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "osnoise_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 457360db0767..c685d881daf1 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -480,9 +480,14 @@ struct osnoise_top_params *osnoise_top_parse_args(int argc, char **argv)
 			params->stop_total_us = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg){
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "osnoise_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 8bd51aab6513..d2a639d3c02c 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -720,9 +720,14 @@ static struct timerlat_hist_params
 			params->stop_total_us = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg) {
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "timerlat_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 8a3fa64319c6..e6e75937832e 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -547,9 +547,14 @@ static struct timerlat_top_params
 			params->stop_total_us = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg) {
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "timerlat_trace.txt";
 
-- 
2.44.0

