Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9AC1E9B3A
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 12:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770554654; cv=none; b=Ag7WjxTT7LnVYrPWR3mp5j4dkL66P20V1Ko5XhrRFhCnV5zrqF7feshOeRvC4WPZCwJy1Glf9cn05f76T6EWc9kgiUmu/gTHKGz7bhGYhF1AXgTZ/wvN/QqPlkkbdjYa/ro84NqF8Pf1PhZc+9LBtI4xbx1cwDNfDFvl7ufZU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770554654; c=relaxed/simple;
	bh=FsNqPfU+WLtwP9WvAUcK82uK6irMNnVYbyybzxTfyr4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CB7S/2tiDGqk3nNUkX7ylPjPnwj5kn+CvGZ+o3T7haxRug6na5BVY4taRbtMp1oVJQYYN2izukpo0DQ6gznaRcDCEP1DabgtPJINDuTeR5UUq4oPfp9PSq/SvqEDkEqv93HR6ZVIxWl/Ku9FaCk8QuAY0K1R+xKvTUSwvOO2qtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TOUElimt; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TOUElimt"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-81f5381d168so3966689b3a.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 08 Feb 2026 04:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770554653; x=1771159453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+YcCU+9EW6fQ3iQGZpjy0c67hFx/h7iRGpvlMCCbir8=;
        b=TOUElimtQzTX3QgA0FIAZU7u4wbNRde7QUI9rachVvvXY1oec8B65O2Ij04uvLCiPO
         tu4y8ZmfiG4GznDrd5Hh1HBagLWfnA61VaRew6EdPYpEMCvX3V3ANCXO24EkbmcP7g9Y
         e6BK+kHErP4BzvfAjM4e/Q0XnEbuChmJDXpMMqgZI4ap0REiyi+IBHsQ4i0aHIZ7hS/6
         qp0rHSaOh8G8lGCHHKg4eAkZFAf7t/pwoY013sqYc3+poJHOIHzHai1yNk2cZdNlg8tR
         BSbVuE9HDzybXIbgVxkgMws82ENf00dVp3GtgI6mu8gc820BHmGFpRcrLkijxSQt+Nnm
         7SEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770554653; x=1771159453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YcCU+9EW6fQ3iQGZpjy0c67hFx/h7iRGpvlMCCbir8=;
        b=JWeDhAy7ACiIx5R1rizuB8LaXWETDaKgEvlpQ0ooJ3fCM0XhQZxfH/KR1PL7BF6aRw
         m3ktnDX4a03s5mmc3ueeo2/5fnmCDQT6WnPd57OYD1AUefON91IiToEKPaauEYSA+WIi
         vhwQOSiXSYJF8c8Np0ec2QkSr/AAyTQ3+hS38NBlrGIGuIj+syYFgeav9KVRTsdiuJNm
         awaRU691xtPahp9nCtKXn1WvOlCd1unRIrXbS6x9NUkEHjGPGz7velKtRa0WeZu32Yvn
         IcRBtiYpREngOFiqD2ANcDW4o1X7905b/REariREsIwOgDsHVJ4y8otoiLqmPE/5hstm
         9mXA==
X-Forwarded-Encrypted: i=1; AJvYcCWiOu1CSIvh6VL12Be7hqeOA7Z+JMFfMvtmMxMjXm3OSU0u3h9PQHYBSeEvXkBqJvvQURBabU5reqFDpPVvQFUAIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvCgWFlmfb8ufTA67rq0se6m8IifJWOW/XWkczCnMmJtzex16Q
	6kD4PZuOxnKzsy3nHGXncOukR/ZPIPZ5IWK7cX8+UXbHTT7lmFZ4HFCs
X-Gm-Gg: AZuq6aJuqOHWd3ZeULYGv4chiE9S5m/l1OLp34cZHwVRT8oicCynmVnBzIVD7pa+lyM
	bASc6KjjfkwAEbr3qNXTAmg7Bfj6F42SUNGVfXCANazXL+eXVZYyRdiZsW0XpkVEzfN2vVIWwX2
	W7vOWxdFJa0a0uo+3F1BNOHVtJzn7UcbQ8az2FybMJmo4tYZ6xfxpzycDEeyOjkE9yzjQpGCuul
	1o30lwtAKJiaUJLVB7TS4r119YeUl48QCVP2jJfxNvETbCzn6KMW2BtDzHYIH+4KQJZfi+UBD8N
	m8s17A2ou2Fn30IpxsspqcDZXmU1MCW/NS68lbo3bMPeGGbNcHRvjeGcMBmfegRoKdiumetRMiq
	G7N6WZzIEw8EeF5RY2hhgEjvp9fluZXPM5/RQUsv05xxlOGCRTmzXEh6jNNFhxXd2jKKGhJM4lf
	W0/y7cn4KLTC+wQ45BeEcME1oUUUk=
X-Received: by 2002:a05:6a00:4507:b0:823:ac8:ed82 with SMTP id d2e1a72fcca58-824417ae506mr7369710b3a.69.1770554653119;
        Sun, 08 Feb 2026 04:44:13 -0800 (PST)
Received: from pengdl-pc.mioffice.cn ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82441882481sm7275856b3a.35.2026.02.08.04.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 04:44:12 -0800 (PST)
From: Donglin Peng <dolinux.peng@gmail.com>
To: rostedt@goodmis.org
Cc: mhiramat@kernel.org,
	linux-trace-devel@vger.kernel.org,
	Donglin Peng <pengdonglin@xiaomi.com>
Subject: [PATCH v2] libtraceevent: Pretty print function parameters of enum-type
Date: Sun,  8 Feb 2026 20:44:06 +0800
Message-Id: <20260208124406.3050593-1-dolinux.peng@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Donglin Peng <pengdonglin@xiaomi.com>

The tep_btf_print_args() function currently prints values of
enum parameters in decimal format, which reduces readability.

Utilize the BTF information to resolve enum type parameters
and print their symbolic names where possible. This enhances
the trace log readability by displaying meaningful identifiers
instead of raw numbers.

Before:
mod_memcg_lruvec_state(lruvec=0xffff88800c18a540, idx=5, val=320)

After:
mod_memcg_lruvec_state(lruvec=0xffff88800c18a540, idx=5 [NR_SLAB_RECLAIMABLE_B], val=320)

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Donglin Peng <pengdonglin@xiaomi.com>
---
v1 -> v2:
 - Refactor for_each_enum helper macro to use internal loop variable __i
   (thanks to Steve)
---
 src/trace-btf.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index 859b0860ce2a..2d66e0113077 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -32,6 +32,16 @@ struct tep_btf {
 #define REALLOC_SIZE (1 << 10)
 #define REALLOC_MASK (REALLOC_SIZE - 1)
 
+#define for_each_enum(enum_type, member)				\
+	member = btf_enum(enum_type);					\
+	for (int __i = 0; __i < BTF_INFO_VLEN((enum_type)->info);	\
+		__i++, member++)
+
+static inline struct btf_enum *btf_enum(struct btf_type *t)
+{
+	return (struct btf_enum *)(t + 1);
+}
+
 static const char *btf_name(struct tep_btf *btf, int off)
 {
 	if (off < btf->hdr->str_len)
@@ -546,6 +556,7 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
 	struct btf_param *param;
+	struct btf_enum *enump;
 	unsigned long long arg;
 	unsigned int encode;
 	const char *param_name;
@@ -628,6 +639,13 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 			break;
 		case BTF_KIND_ENUM:
 			trace_seq_printf(s, "%lld", arg);
+			for_each_enum(t, enump) {
+				if (arg == enump->val) {
+					trace_seq_printf(s, " [%s]",
+						btf_name(btf, enump->name_off));
+					break;
+				}
+			}
 			break;
 		default:
 			/* This does not handle complex arguments */
-- 
2.34.1

