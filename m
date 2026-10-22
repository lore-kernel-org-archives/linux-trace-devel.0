Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792709638;
	b=D6Ub5IJiIM2HuBfmEGq29vzRG8uwrQ6iqRHMj8HVrsMfrMXtWN4VOGDObLfu6xxycpro
	 GAi9lc4OunPdFBd5yIOSznKsvDsosJrzMfy/kQ/XMmVNyvQ3+98v/IAmCwThJFWCRSvdZ
	 wS/TIf7+qDGisq0MQC+BEM/rXbbVvTQIFX0Iutu//gkSOPHvk3f2d38N4fapdZVphqlhA
	 QMOVaS9MHOnQVxaqjC55dO3GzeG7bj4i3CypUtM1J+BwjQOaWUqOlIabO06cEvExv+BFC
	 j3/gEqo2NyffGj40i0C65WrS3sXLHVUn3+FrC8dppH2evBakUM+BjoKyr3zI4DBpwsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792709638;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQuqrUg74/iBvmRH4oieNHzq/FjwgG47Pp144KlY4FA=;
	b=YWOVEStGpvcpQmy10ciToER2VQPaLt+I/qA1M6z0W/GM27mvuMQ9+iO5sufhbs56Scj+
	 mwQSmz1yO9C6ikzqSj2fQ615PPcKYCKdQYZXza9qv4VR/VI2YEvllbXH4IbET4Ark8uRK
	 /0peO/2MFxo7vieAh+Fl9jZYmfn1WVGR9AhLQp4zAtkXf61F3rmhhnXU5uU5nqi/CND06
	 PQQC+U8/DDBuppuGxjw85unVmnXOppvEKjs49G8JhKK9+rTMFOuGQyLaQy3bf2pW8KYZv
	 7kKfb6NX80vfoFKv3Yo/HF+lf+YU/j0Nt3bupX2/4Mv6UUopOa4mC5WYajyBUTRxJxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=GodUyAfu;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8893D606A319
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8893D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=GodUyAfu
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9B68C3FE99
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792709634;
	bh=WQuqrUg74/iBvmRH4oieNHzq/FjwgG47Pp144KlY4FA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=GodUyAfupkzf8C/04lAeGdwTIrZ7D7kFxuEjVcI33lrIhFGUFdgfX0jZQrPZb4L+c
	 5JdBzmoX5O5+LZNEEq3LiwnnaoPzABoQgBgcBNJaziXUzYQhCFYgFMLebvpL23iXz1
	 70sGzhE1kVq0AseNBfaEGjuAKucANSQMLRClAFRpAY+CdesjfgFCEvH1Ap5Y9CoOVB
	 F1wm2YNNypKUMkmngE/kBMqW/gmV3zRSHxsMKeWDdPKykhhkr+YX0jlOo7iv9+/HB9
	 bxR7+ZTLELh7LvlOFacsFYsMk6DZF3GshO6HHEWz08IcWRcZ5XokhbUtfc8TuRr0zE
	 /ZgSbre5oLe+lJ6WU9oX+pyqeprwUrIQe8UBuNYZ4mi2AQrivGs/bKnAl7ByaBMNxy
	 /UuExosTjct9QKBhwQmE7wQAwd/LXVnE6rLzlIUVE0OxJO1mbocKnJRBfpgqskal6R
	 yPs/KliOnzWJu2UizeoSUJOaSkUBWxhB+nIrbYCdQkNGnz7JAIah0ATXUfiyideXU1
	 e9xFkszh7gXdauQCiDd7xQL5h+c+dTHAl9EUeVFFdZVGheEuiDBM5Aa2pHPEvx7BKq
	 OhshmCiaqZo1hPnALJ68+p4MjwfnSEReCaKLKxEd4lUZi+ToCWOkSohyfpXnkdBh1Y
	 tJ8Gp16o7yjbe7bwawn/qnQA=
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48df5b058ddso148524f8f.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709634; x=1793314434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WQuqrUg74/iBvmRH4oieNHzq/FjwgG47Pp144KlY4FA=;
        b=Y7a0P92X/qVws281NOVE+6l2aTy9ZqUph1hh6HQlsNwww9GR+d4tmDXWvzZC0W/Tvg
         z2zLnKKj4fSVGT9DjMDowX6EiUhaXn/LSYFWwHZTQ8vWzUhhZMfqulFobqx5lfEYZZwT
         EHzcMM7/5xtDHFx15B6/7aijUzx5Dxbdg1ew3L1qX7mdNev430I4Q48IJ9ogJxR8w9FG
         m6iGH8jNlU5p/fY8Czorm9qqV+2SjpYRfvfkYf6be4+j/kGErNY33HHy8nhopu9v/ANW
         URMqFk1UpSsad7DhNbvgmAkkAS9suQnaUsZdDvNqXEaSxMRddp2FKEccxfS6hGi1Uebw
         CYFQ==
X-Gm-Message-State: AFq9FYLlhxY3cB3idncbvNsD/5fGJ0YjaFGhOn7o1VYlXxH4AQe92/Ew
	R7kETUoWNwqWrflaB5CskGAcvFS790dTaf+KEHOZJxGPDPEFtQHMiXvzfTlpdnCA1Jsl/fZVVBj
	DVtHaMG2d4lLux/yT5iVj+uRJg0QNibtvMp6L6LPDfEysLSh+JzjJBPinhvmxQ6lYG0dB33XlA9
	WhHTkYt+gOm4N6siJVxlGK
X-Gm-Gg: AYBFou14DMMNI6IRr6nskhJ+3QUj6jMprUJ6r04F6bTTpKyxPSk/0d4VByiybznlIav
	l51A8SnxQe3A1+D3Jix1oL4nVM7vD1DsMsaOEGPs5nwg5XoJafd87YIkKiuHJCOTo+hV/p+mHGo
	2Nq8w86I2ZBwBsCCbZM8FKXxFrLOEply1UPJlRieOgZTSiYIoe30duiVCSRpECEeLPHgd0lWJe/
	tKCuPlvOOHuewG8Gcv1dX4jTIgK3ypdwOWM1AxCLpzD3uBy7W/YfQSSiHtmlYNgY8vaiQIqqd4E
	KQo9GsM3epWT/xO/leb3FPZg7FjDlMoT3q7kC6AjZubUngeYElqp8aQyTyNF3XOPQblpItDoxNO
	z+mwISXo4UzrrGECCkZJOHHU5Oxe81C11tAKkQXSafKI2s5C3kEiqBv0zrnttlKjIPZHCirBa5y
	RrHg0=
X-Received: by 2002:a05:6000:238a:b0:48a:ef5c:fc2c with SMTP id ffacd0b85a97d-48e385adbe7mr353667f8f.48.1792709634008;
        Thu, 22 Oct 2026 15:53:54 -0700 (PDT)
X-Received: by 2002:a05:6000:238a:b0:48a:ef5c:fc2c with SMTP id ffacd0b85a97d-48e385adbe7mr353648f8f.48.1792709633537;
        Thu, 22 Oct 2026 15:53:53 -0700 (PDT)
Received: from curves.ddrung.de (2a00-12d0-b0ea-16f0-e90a-519c-7703-6c41.ip.tng.de. [2a00:12d0:b0ea:16f0:e90a:519c:7703:6c41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38063d63sm813449f8f.56.2026.10.22.15.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:53:52 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 1/2] libtracefs Documentation: correct name of GPL
Date: Fri, 23 Oct 2026 00:53:11 +0200
Message-ID: <20261022225313.1953932-1-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GPL stands for "General Public License".

Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 Documentation/libtracefs-cpu-buf.txt              | 2 +-
 Documentation/libtracefs-cpu-map.txt              | 2 +-
 Documentation/libtracefs-cpu-open.txt             | 2 +-
 Documentation/libtracefs-cpu.txt                  | 2 +-
 Documentation/libtracefs-dynevents.txt            | 2 +-
 Documentation/libtracefs-eprobes.txt              | 2 +-
 Documentation/libtracefs-error.txt                | 2 +-
 Documentation/libtracefs-events-file.txt          | 2 +-
 Documentation/libtracefs-events-tep.txt           | 2 +-
 Documentation/libtracefs-events.txt               | 2 +-
 Documentation/libtracefs-files.txt                | 2 +-
 Documentation/libtracefs-filter-pid.txt           | 2 +-
 Documentation/libtracefs-filter.txt               | 2 +-
 Documentation/libtracefs-function-filter.txt      | 2 +-
 Documentation/libtracefs-guest.txt                | 2 +-
 Documentation/libtracefs-hist-cont.txt            | 2 +-
 Documentation/libtracefs-hist-mod.txt             | 2 +-
 Documentation/libtracefs-hist.txt                 | 2 +-
 Documentation/libtracefs-instances-affinity.txt   | 2 +-
 Documentation/libtracefs-instances-file-manip.txt | 2 +-
 Documentation/libtracefs-instances-files.txt      | 2 +-
 Documentation/libtracefs-instances-manage.txt     | 2 +-
 Documentation/libtracefs-instances-stat.txt       | 2 +-
 Documentation/libtracefs-instances-subbuf.txt     | 2 +-
 Documentation/libtracefs-instances-utils.txt      | 2 +-
 Documentation/libtracefs-iterator.txt             | 2 +-
 Documentation/libtracefs-kprobes.txt              | 2 +-
 Documentation/libtracefs-log.txt                  | 2 +-
 Documentation/libtracefs-marker.txt               | 2 +-
 Documentation/libtracefs-marker_raw.txt           | 2 +-
 Documentation/libtracefs-option-get.txt           | 2 +-
 Documentation/libtracefs-option-misc.txt          | 2 +-
 Documentation/libtracefs-options.txt              | 2 +-
 Documentation/libtracefs-snapshot.txt             | 2 +-
 Documentation/libtracefs-sql.txt                  | 2 +-
 Documentation/libtracefs-sqlhist.txt.1            | 2 +-
 Documentation/libtracefs-stream.txt               | 2 +-
 Documentation/libtracefs-synth-info.txt           | 2 +-
 Documentation/libtracefs-synth.txt                | 2 +-
 Documentation/libtracefs-synth2.txt               | 2 +-
 Documentation/libtracefs-traceon.txt              | 2 +-
 Documentation/libtracefs-tracer.txt               | 2 +-
 Documentation/libtracefs-uprobes.txt              | 2 +-
 Documentation/libtracefs-utils.txt                | 2 +-
 Documentation/libtracefs.txt                      | 2 +-
 45 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/Documentation/libtracefs-cpu-buf.txt b/Documentation/libtracefs-cpu-buf.txt
index 943cb1f..d591932 100644
--- a/Documentation/libtracefs-cpu-buf.txt
+++ b/Documentation/libtracefs-cpu-buf.txt
@@ -168,4 +168,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-cpu-map.txt b/Documentation/libtracefs-cpu-map.txt
index d961123..8a9f14f 100644
--- a/Documentation/libtracefs-cpu-map.txt
+++ b/Documentation/libtracefs-cpu-map.txt
@@ -215,4 +215,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-cpu-open.txt b/Documentation/libtracefs-cpu-open.txt
index 613a71d..a17daf2 100644
--- a/Documentation/libtracefs-cpu-open.txt
+++ b/Documentation/libtracefs-cpu-open.txt
@@ -107,4 +107,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-cpu.txt b/Documentation/libtracefs-cpu.txt
index 6fb6524..eba316b 100644
--- a/Documentation/libtracefs-cpu.txt
+++ b/Documentation/libtracefs-cpu.txt
@@ -240,4 +240,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index 2c6db47..bd5fbfd 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -280,4 +280,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-eprobes.txt b/Documentation/libtracefs-eprobes.txt
index a96ad1b..0ef267b 100644
--- a/Documentation/libtracefs-eprobes.txt
+++ b/Documentation/libtracefs-eprobes.txt
@@ -184,4 +184,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-error.txt b/Documentation/libtracefs-error.txt
index a45332d..44155a4 100644
--- a/Documentation/libtracefs-error.txt
+++ b/Documentation/libtracefs-error.txt
@@ -134,4 +134,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-events-file.txt b/Documentation/libtracefs-events-file.txt
index 1a298b3..4a56cf3 100644
--- a/Documentation/libtracefs-events-file.txt
+++ b/Documentation/libtracefs-events-file.txt
@@ -213,4 +213,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
index ba46532..365e225 100644
--- a/Documentation/libtracefs-events-tep.txt
+++ b/Documentation/libtracefs-events-tep.txt
@@ -150,4 +150,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index 90c54b8..c8286d5 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -192,4 +192,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-files.txt b/Documentation/libtracefs-files.txt
index d22e759..f77af46 100644
--- a/Documentation/libtracefs-files.txt
+++ b/Documentation/libtracefs-files.txt
@@ -128,4 +128,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-filter-pid.txt b/Documentation/libtracefs-filter-pid.txt
index fa56b02..68236c2 100644
--- a/Documentation/libtracefs-filter-pid.txt
+++ b/Documentation/libtracefs-filter-pid.txt
@@ -178,4 +178,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2023 Google, LLC. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
index 12726b9..9d0ccc3 100644
--- a/Documentation/libtracefs-filter.txt
+++ b/Documentation/libtracefs-filter.txt
@@ -342,4 +342,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 2a141fd..88d5d06 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -234,4 +234,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-guest.txt b/Documentation/libtracefs-guest.txt
index 16ce020..b9d6418 100644
--- a/Documentation/libtracefs-guest.txt
+++ b/Documentation/libtracefs-guest.txt
@@ -185,4 +185,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 7159e27..86fb980 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -219,4 +219,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-hist-mod.txt b/Documentation/libtracefs-hist-mod.txt
index b308c7e..e51c823 100644
--- a/Documentation/libtracefs-hist-mod.txt
+++ b/Documentation/libtracefs-hist-mod.txt
@@ -537,4 +537,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 7503fd0..dba88ea 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -528,4 +528,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 39dd44c..2283ae5 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -197,4 +197,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-file-manip.txt b/Documentation/libtracefs-instances-file-manip.txt
index bb1b36e..5dca8f3 100644
--- a/Documentation/libtracefs-instances-file-manip.txt
+++ b/Documentation/libtracefs-instances-file-manip.txt
@@ -203,4 +203,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-files.txt b/Documentation/libtracefs-instances-files.txt
index e298557..0f91f01 100644
--- a/Documentation/libtracefs-instances-files.txt
+++ b/Documentation/libtracefs-instances-files.txt
@@ -170,4 +170,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index 72f177a..8b4f598 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -157,4 +157,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-stat.txt b/Documentation/libtracefs-instances-stat.txt
index d3bb3c9..fce55c3 100644
--- a/Documentation/libtracefs-instances-stat.txt
+++ b/Documentation/libtracefs-instances-stat.txt
@@ -180,4 +180,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-subbuf.txt b/Documentation/libtracefs-instances-subbuf.txt
index 8d5c3e0..d18b64e 100644
--- a/Documentation/libtracefs-instances-subbuf.txt
+++ b/Documentation/libtracefs-instances-subbuf.txt
@@ -149,4 +149,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index d2c4f16..c2ee9ad 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -164,4 +164,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
index b62f66a..d2e24dd 100644
--- a/Documentation/libtracefs-iterator.txt
+++ b/Documentation/libtracefs-iterator.txt
@@ -262,4 +262,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index 199379a..dc4c611 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -282,4 +282,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-log.txt b/Documentation/libtracefs-log.txt
index 4b72df1..7bbda0d 100644
--- a/Documentation/libtracefs-log.txt
+++ b/Documentation/libtracefs-log.txt
@@ -73,4 +73,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-marker.txt b/Documentation/libtracefs-marker.txt
index adc5419..201312a 100644
--- a/Documentation/libtracefs-marker.txt
+++ b/Documentation/libtracefs-marker.txt
@@ -113,4 +113,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-marker_raw.txt b/Documentation/libtracefs-marker_raw.txt
index 9682f20..6d802dd 100644
--- a/Documentation/libtracefs-marker_raw.txt
+++ b/Documentation/libtracefs-marker_raw.txt
@@ -99,4 +99,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index 8a688a7..ca48b20 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -138,4 +138,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-option-misc.txt b/Documentation/libtracefs-option-misc.txt
index c690bfd..2070d27 100644
--- a/Documentation/libtracefs-option-misc.txt
+++ b/Documentation/libtracefs-option-misc.txt
@@ -97,4 +97,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-options.txt b/Documentation/libtracefs-options.txt
index 2c720f2..ec93471 100644
--- a/Documentation/libtracefs-options.txt
+++ b/Documentation/libtracefs-options.txt
@@ -156,4 +156,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-snapshot.txt b/Documentation/libtracefs-snapshot.txt
index 896705c..04477af 100644
--- a/Documentation/libtracefs-snapshot.txt
+++ b/Documentation/libtracefs-snapshot.txt
@@ -179,4 +179,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2023 Google, LLC. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 806fbe4..a7e7e8f 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -654,4 +654,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-sqlhist.txt.1 b/Documentation/libtracefs-sqlhist.txt.1
index 875b250..75e93e1 100644
--- a/Documentation/libtracefs-sqlhist.txt.1
+++ b/Documentation/libtracefs-sqlhist.txt.1
@@ -352,5 +352,5 @@ https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
 COPYING
 -------
 Copyright \(C) 2021 , Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
 
diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index 7f1ff6a..e88c0b0 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -124,4 +124,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-synth-info.txt b/Documentation/libtracefs-synth-info.txt
index 6ee0320..ba962ba 100644
--- a/Documentation/libtracefs-synth-info.txt
+++ b/Documentation/libtracefs-synth-info.txt
@@ -295,4 +295,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index c57725d..997de8a 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -365,4 +365,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index 77cdd01..f976c93 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -293,4 +293,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-traceon.txt b/Documentation/libtracefs-traceon.txt
index 28c79ed..1e2f832 100644
--- a/Documentation/libtracefs-traceon.txt
+++ b/Documentation/libtracefs-traceon.txt
@@ -148,4 +148,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-tracer.txt b/Documentation/libtracefs-tracer.txt
index 8f90552..a77ab5c 100644
--- a/Documentation/libtracefs-tracer.txt
+++ b/Documentation/libtracefs-tracer.txt
@@ -234,4 +234,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-uprobes.txt b/Documentation/libtracefs-uprobes.txt
index 1ca80da..47d0333 100644
--- a/Documentation/libtracefs-uprobes.txt
+++ b/Documentation/libtracefs-uprobes.txt
@@ -186,4 +186,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2022 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index ab16cc6..751e3f3 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -136,4 +136,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 860e2be..78dc2a5 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -405,4 +405,4 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 COPYING
 -------
 Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
-the terms of the GNU Public License (GPL).
+the terms of the GNU General Public License (GPL).
-- 
2.53.0

