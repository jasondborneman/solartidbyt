load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("os.star", "os")

SOLAR_API_KEY = "<SOLAR EDGE API KEY>"
SOLAR_SITE_ID = "< SOLAR EDGE SITE ID>"

SOLAR_SITE_OVERVIEW_URL = "https://monitoringapi.solaredge.com/site/%s/overview?api_key=%s" % (SOLAR_SITE_ID, SOLAR_API_KEY)

BOLT_IMG = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpSIVBTuICGaoTlZERRy1CkWoEGqFVh1MLv0QmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi5uak6CIl/i8ptIjx4Lgf7+497t4BQq3ENKttDNB020wl4mImuyKGXhHEIHowCkFmljErSUn4jq97BPh6F+NZ/uf+HF1qzmJAQCSeYYZpE68TT23aBud94ggryirxOfGISRckfuS64vEb54LLAs+MmOnUHHGEWCy0sNLCrGhqxJPEUVXTKV/IeKxy3uKslSqscU/+wnBOX17iOs0BJLCARUgQoaCCDZRgI0arToqFFO3Hffz9rl8il0KuDTByzKMMDbLrB/+D391a+YlxLykcB9pfHOdjCAjtAvWq43wfO079BAg+A1d601+uAdOfpFebWvQI6N4GLq6bmrIHXO4AfU+GbMquFKQp5PPA+xl9UxbovQU6V73eGvs4fQDS1FXyBjg4BIYLlL3m8+6O1t7+PdPo7wdh7nKgfF1M3QAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+UDHxE4LP0kBNcAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAABuElEQVQ4y4WTS0iUURiGn7/GxglDkIxZqLjzliBjRpI6sxW8LLySIEKQoITuCkFHoVVgQeTGlagLdREIWaaC4Ea0NO8uouD/Z2EXGdRRZ8ZGvxbZ4N+ccT44i/Oe930/znfRRARlTLU68H74hJxoYUyznmIvdeB6tfYPsijFoWM42Ozm91fNhNtcAxfFAFeUBrNP8gmslJuwq+k+7K7O/6lqg73VLmTfjMVnPqfIvRPbYPpxPsGP5uxxuR4y6l+qckUa7K+7kYD576Hv8Sw1zTF8c4n3D29HN5hpv4N/sSzCVH4lo+HAlrdu5Lg3Lj5ppjau9icQOkkE4HDnLp7eN0jwvF85P0h/kE1hh9dsLhJxdF1HxoreySAig4gMXRN521it4mrKQZp8dI/dkXnE9/eeUDlPam0LAFarQW6VN2oRDcMA33ZPWAxwOF7IdsNnvr3oIvAleGkX0ixbFiz+Pq5nVhKX4QkP7I2K19x/VkPB06OYNRARZLK5QIasIsP2Uxmva9d1XclT7wLAwWYbWtIRtqw6KkYm0qLQ1AYLvSmcBUpILC6hbHSZS0K9C/6fTm45nbHEAH8APSDZdAjTwXoAAAAASUVORK5CYII=""")
SMOKESTACK_IMG = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpSIVBTuICGaoTlZERRy1CkWoEGqFVh1MLv0QmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi5uak6CIl/i8ptIjx4Lgf7+497t4BQq3ENKttDNB020wl4mImuyKGXhHEIHowCkFmljErSUn4jq97BPh6F+NZ/uf+HF1qzmJAQCSeYYZpE68TT23aBud94ggryirxOfGISRckfuS64vEb54LLAs+MmOnUHHGEWCy0sNLCrGhqxJPEUVXTKV/IeKxy3uKslSqscU/+wnBOX17iOs0BJLCARUgQoaCCDZRgI0arToqFFO3Hffz9rl8il0KuDTByzKMMDbLrB/+D391a+YlxLykcB9pfHOdjCAjtAvWq43wfO079BAg+A1d601+uAdOfpFebWvQI6N4GLq6bmrIHXO4AfU+GbMquFKQp5PPA+xl9UxbovQU6V73eGvs4fQDS1FXyBjg4BIYLlL3m8+6O1t7+PdPo7wdh7nKgfF1M3QAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+UDHxQWIY5Zs60AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACG0lEQVQ4y12Sv2sVQRSFvzu7iySgaITYaARNAhYaYoggJPgPCIKxtBBEoq1o4zPwCkOKIPZPsBERxZBCbBQLQQhISLT0ByLBKkosNDazc67NLC5ZGIb55pyZc+cuRVGUIYRQFEUoy7JcXFysJN2WNFzXdYgxlpLGUtKluq5Dw1LSfIyxpGWu5ubmKkkXJK3EGEOMsUopjUtalnSmrusgaUDSLUkPYoyBxtztditJNyTdk3Qgm4+kpNeSpvPNVUppSdLlGOv+uq4DZVmW3W63ijFWku6klMoYY7M+J2mmMWf2qF1KWFhYsE6nQ1EUFTAINs3/7wRwzN0LgKIopoDtEMKuzIwYY5lr2yPJU0rXYoxVZmuS1lq3X82avZmVwcwE4O4BwMwws9RKYZknwNsMUMjmog13MG8dGPLsZpbMjDKEMOHuZmZ9eXOoYUAf4CGEcSC4+6Gc8LiZ/QWCSdoA5oHrwF3gors/M7NJ4FtOcdjdV81sBngI3MzaTgB+AY+BTXd/CnwFloB3wEvglbuvZvYFeNLSbpnkP8CXgbPAC2AKWAGGgZ85wf5sPg28zdrnwHkkX8stepPnXm7pbErpVEqalHQls/uNtmmzSfoNrOef5j0wmssYBP7k1u0GNoGjwCdgDPgAnETS+o5TeymlfZJmJU3kMZtZL2uatOsmaRvsI/gI8BkYAr4DA8B2foN+YAs4CGwAI/lNRv8Bq7O39VVYV/EAAAAASUVORK5CYII=""")
TREE_IMG = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAPCAYAAADtc08vAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9TpSIVBTuICGaoTlZERRy1CkWoEGqFVh1MLv0QmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi5uak6CIl/i8ptIjx4Lgf7+497t4BQq3ENKttDNB020wl4mImuyKGXhHEIHowCkFmljErSUn4jq97BPh6F+NZ/uf+HF1qzmJAQCSeYYZpE68TT23aBud94ggryirxOfGISRckfuS64vEb54LLAs+MmOnUHHGEWCy0sNLCrGhqxJPEUVXTKV/IeKxy3uKslSqscU/+wnBOX17iOs0BJLCARUgQoaCCDZRgI0arToqFFO3Hffz9rl8il0KuDTByzKMMDbLrB/+D391a+YlxLykcB9pfHOdjCAjtAvWq43wfO079BAg+A1d601+uAdOfpFebWvQI6N4GLq6bmrIHXO4AfU+GbMquFKQp5PPA+xl9UxbovQU6V73eGvs4fQDS1FXyBjg4BIYLlL3m8+6O1t7+PdPo7wdh7nKgfF1M3QAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+UDHxQkKBr1X3gAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACi0lEQVQoz41SS2gTURQ9781kZpLRQJAarG3VIoW6keIH04VY3CjoShRJ3bmwtbjVjVC3bsSlWkWk4Ae/+F2orYq4EkVTRaHS+kmxaTN5ZpLMy7w377mI1CoiPXDhci/3nHMvl3ieB8uyIKVEMplEqVTCWHCv5c3Mwz0ayBKKpnR89eCqeNft9ct3eKVSCclkElEUgXMO4nke4vE4KKXgnGP406G2kNSeF8K7rZiHOFn7uTvVv3HLyt4C5xyUUpimCQoAWmtIKVFzJ11fsJv56mirFC7EvCiH4yvG/ZcHanUfpmmCEAIpZcOBbdt4Ubi2ZPTr8NsfMtcMAOSXsp7ngoCiLb7tTv+mwd0mT9ellKCUUhiGgQ9T77ZPVz8287oFXrcQ1G0Ev/LftRg+ssc7Tz49NhBFERzHaTgY/XoNDyYv6Go0jYXANdLV/euOtnQuyjCTEIJIA9MVDxrmggh8FN37uVvtXT09r0ytNXZ07MMX7/vx2xOXjyyEYKnVMrNr7f53WuvfR3RdFwNX+s5FWu2tikrBq3uxbzy//O/h7qbM9Vqt3Hdq7/lZKSUIYwyO48AwDJTLZaRSKQw9O5tRGp2sxsisX0yMFd8vzrRsWDTl5x+d2Xd6hDEG0zRh23bDgWVZUEohkUjA9304joODlw73/6iXB23DHhnKnsgSQmDbNnzfh+u6iKIIQojGI1FKEYvFwDmH4zhQSiG7uffijXwuHQr9mlIKQshcXwgBpRRisViD4F/oWNauUSe4PpFj/zsoBQClFMIwRCKRQBAEoJTi6pN7a8Aj9HVs7YqiaG7FIAhgWRYMw0AYhgBjDJxzCCFQLBahlEKlUvlDhXOOIAjm+owxVCoVCCHwE1LlWw0Bx89JAAAAAElFTkSuQmCC""")

def main():
    print ("----Getting Solar Overview----")
    resp = http.get(SOLAR_SITE_OVERVIEW_URL)
    if resp.status_code != 200:
        fail("SolarEdge Overview request failed with status %d" % resp.status_code)
    print ("----Got Solar Overview----")
    resp_json = resp.json()

    current_power = resp_json["overview"]["currentPower"]["power"]
    lifetime_energy = "%s" % (float(resp_json["overview"]["lifeTimeData"]["energy"])/1000000)
    # lifetime_energy = "11.0234567890"
    energy_split = lifetime_energy.split(".", 1)
    major_energy = energy_split[0]
    minor_energy = energy_split[1][0:3]
    kwh_s = "{maj}{min}".format(maj=major_energy, min=minor_energy)
    kwh = int(kwh_s)
    co2 = kwh * 0.92 # https://www.eia.gov/tools/faqs/faq.php?id=74&t=11
    co2_metric_tons = co2 * 0.000453592 # pounds to metric tons
    tree_acres_float = "{}".format(co2_metric_tons * 0.77) # https://www.epa.gov/energy/greenhouse-gases-equivalencies-calculator-calculations-and-references
    trees_split = tree_acres_float.split(".", 1)
    major_trees = trees_split[0]
    minor_trees = trees_split[1][0:3]
    tree_acres = "{}.{}".format(major_trees, minor_trees)

    return render.Root(
        delay = 5000,
        child = render.Box( # This Box exists to provide vertical centering
            render.Animation(
                children = [
                    render.Column(
                        main_align="space_around", # Controls horizontal alignment
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Box(
                                        width = 16,
                                        height = 16,
                                        child = render.Image(src=BOLT_IMG),
                            ),
                            render.Box(
                                render.Row(
                                    expanded=False,
                                    main_align="space_evenly",
                                    cross_align="center",
                                    children = [
                                        render.Row(
                                            children = [render.Text("{} KWh".format(kwh))]
                                        )
                                    ]
                                )
                            )
                        ],
                    ),
                    render.Column(
                        main_align="space_around", # Controls horizontal alignment
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Box(
                                        width = 16,
                                        height = 16,
                                        child = render.Image(src=SMOKESTACK_IMG),
                            ),
                            render.Box(
                                render.Row(
                                    expanded=False,
                                    main_align="space_evenly",
                                    cross_align="center",
                                    children = [
                                        render.Row(
                                            children = [render.Text("{} # CO2".format(co2))]
                                        )
                                    ]
                                )
                            )
                        ],
                    ),
                    render.Column(
                        main_align="space_around", # Controls horizontal alignment
                        cross_align="center", # Controls vertical alignment
                        children = [
                            render.Box(
                                        width = 16,
                                        height = 16,
                                        child = render.Image(src=TREE_IMG),
                            ),
                            render.Box(
                                render.Row(
                                    expanded=False,
                                    main_align="space_evenly",
                                    cross_align="center",
                                    children = [
                                        render.Row(
                                            children = [render.Text("{} Acres".format(tree_acres))]
                                        )
                                    ]
                                )
                            )
                        ],
                    ),
                ]
            )
        ),
    )

